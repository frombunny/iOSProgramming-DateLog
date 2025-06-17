package com.ios.datelog.global.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ios.datelog.domain.user.exception.UserErrorCode;
import com.ios.datelog.global.auth.exception.AuthErrorCode;
import com.ios.datelog.global.auth.exception.InvalidTokenException;
import com.ios.datelog.global.response.ErrorResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 인증이 아예 없는 요청이 보호 자원에 접근했을 때 또는 로그인 시도 실패 시 호출
 * -> 이 경우 컨트롤러나 @RestControllerAdvice까지 응답이 도달하지 못하므로 일반 응답과 동일한 응답을 내려주기 위해 필요
 */
@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
                         AuthenticationException authException) throws IOException, ServletException {
        ErrorResponse<?> errorResponse;

        if(authException instanceof UsernameNotFoundException) {
            errorResponse = ErrorResponse.from(UserErrorCode.USER_NOT_FOUND_404);
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        } else if (authException.getCause() instanceof InvalidTokenException) {
            errorResponse = ErrorResponse.from(AuthErrorCode.INVALID_TOKEN_401);
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        } else {
            errorResponse = ErrorResponse.from(AuthErrorCode.UNAUTHORIZED_401);
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        }
        response.setContentType("application/json;charset=UTF-8");
        objectMapper.writeValue(response.getWriter(), errorResponse);
    }
}
