package com.ios.datelog.global.auth;

import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.exception.UserNotFoundException;
import com.ios.datelog.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service("jwtDetailsService")     // 토큰 검증(PK) 전용
@RequiredArgsConstructor
public class JwtUserDetailsService implements UserDetailsService {
    private final UserRepository userRepository;

    /**
     * UsernameNotFoundException은 스프링 시큐리티의 인증 필터 체인에 처리되기 때문에,
     * 일반적인 MVC 컨트롤러 예외를 처리하는 @RestControllerAdvice(GlobalExceptionHandler)까지 기본적으로 전달되지 않는다.
     */
    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
            try {
                User user = userRepository.getUserById(Long.parseLong(id));
                return new UserPrincipal(user);
            } catch (UserNotFoundException e) { // UserNotFoundException → UsernameNotFoundException 으로 래핑
                // EntryPoint의 instanceof UsernameNotFoundException 분기가 실행
                throw new UsernameNotFoundException(e.getMessage(), e);
            }
    }
}
