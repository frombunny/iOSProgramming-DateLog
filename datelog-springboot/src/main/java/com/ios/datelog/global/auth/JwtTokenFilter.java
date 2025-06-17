package com.ios.datelog.global.auth;

import com.ios.datelog.global.auth.exception.InvalidTokenException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.GenericFilterBean;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JwtTokenFilter extends GenericFilterBean {
    private final JwtTokenProvider jwtTokenProvider;

    /**
     * 요청이 들어올 떄마다 실행되어 Jwt를 검증하는 메소드
     */
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        try{
            String token = jwtTokenProvider.resolveToken(request);
            if (token != null) {
                jwtTokenProvider.validateToken(token); // 유효하지 않으면 Exception
                jwtTokenProvider.setSecurityContext(token); // 인증 완료 상태로 등록
            }
            filterChain.doFilter(servletRequest, servletResponse);
        }catch(InvalidTokenException e){
            // AuthenticationServiceException으로 변환하여 예외 던진다
            // -> AuthenticationException 계열이어야 Entry Point 호출
            throw new AuthenticationServiceException("INVALID_TOKEN",e);
        }
    }
}
