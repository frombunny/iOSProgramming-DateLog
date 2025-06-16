package com.ios.datelog.domain.user.entity;

import com.ios.datelog.domain.user.web.dto.SignUpReq;
import com.ios.datelog.global.entity.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Getter
@Builder
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "user")
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nickname;

    private String password;

    private String profileImage;

    private String email;

    public static User toEntity(SignUpReq signUpReq, String imgUrl, String password){
        return User.builder()
                .nickname(signUpReq.nickname())
                .password(password)
                .profileImage(imgUrl)
                .email(signUpReq.email())
                .build();
    }
}
