package com.ios.datelog.global.auth;

import com.ios.datelog.global.auth.exception.InvalidTokenException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Base64;
import java.util.Date;

@Component
@RequiredArgsConstructor
public class JwtTokenProvider {
    private final MyUserDetailsService userDetailsService;

    @Value("${application.security.jwt.secret-key}")
    private String secretKey;

    @Value("${application.security.jwt.expiration}")
    private long validityInSeconds;

    /**
     * secretKey 초기화
     */
    @PostConstruct
    public void init(){
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    /**
     * 토큰 생성
     */
    public String createToken(Long id){
        Date now = new Date();
        Date expiration = new Date(now.getTime() + validityInSeconds);

        return Jwts.builder()
                .setSubject(String.valueOf(id)) // subject는 pk인 id
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(getSignKey(secretKey), SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Jwt 서명 생성
     */
    public Key getSignKey(String secretKey){
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Jwt에서 사용자 정보를 꺼내, Authentic 객체를 Spring Security에 인증 완료 상태로 등록
     */
    public void setSecurityContext(String token){
        Claims claims = getClaims(token);
        String user = claims.getSubject();

        UserDetails userDetails = userDetailsService.loadUserByUsername(user);

        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    /**
     * 토큰에 있는 속성(클레임)을 가져옴
     */
    public Claims getClaims(String token){
        return Jwts.parserBuilder().setSigningKey(getSignKey(secretKey)).build().parseClaimsJws(token).getBody();
    }

    /**
     * 헤더에서 토큰 추출
     */
    public String resolveToken(HttpServletRequest request){
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    /**
     * 토큰 유효성 검증
     */
    public boolean validateToken(String token){
        if(token == null || token.isEmpty()){
            throw new InvalidTokenException();
        }
        try{
            Jwts.parserBuilder()
                    .setSigningKey(getSignKey(secretKey))
                    .build()
                    .parseClaimsJws(token);
            return true;
        }catch (JwtException | IllegalArgumentException e){
            throw new InvalidTokenException();
        }
    }
}
