package com.ios.datelog.global.auth;

import com.ios.datelog.domain.user.entity.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

/**
 * UserDetails는 인증된 사용자 정보를 담는 객체 역할
 */
@Getter
public class UserPrincipal implements UserDetails {
    private final Long id;
    private final String email;
    private final String password;

    public UserPrincipal(User user) {
        this.id = user.getId();
        this.email = user.getEmail();
        this.password = user.getPassword();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of();
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    /**
     * 계정을 사용할 수 있는 상태인지 확인(ex. 계정 비활성화 여부 확인)
     */
    @Override
    public boolean isEnabled() {
        return true;
    }

    /**
     * 크리덴셜이 만료되었는지 확인(ex. 90일마다 비밀번호 변경 정책이 있을 때 사용)
     */
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    /**
     * 계정 잠금 여부 확인(ex. 비밀번호 5회 실패)
     */
    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    /**
     * 계정 만료 여부 확인
     */
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }
}
