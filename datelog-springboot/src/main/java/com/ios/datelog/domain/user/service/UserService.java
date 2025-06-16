package com.ios.datelog.domain.user.service;

import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.exception.UserAlreadyExistException;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.domain.user.web.dto.SignUpReq;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    public void signUp(SignUpReq signUpReq){
        if(userRepository.findByNickname(signUpReq.nickname()).isPresent()|| userRepository.findByEmail(signUpReq.email()).isPresent()){
            throw new UserAlreadyExistException();
        }

        // TODO: 추후 이미지 업로드 로직 추가
        String imgUrl = null;

        String password = bCryptPasswordEncoder.encode(signUpReq.password());
        User user = User.toEntity(signUpReq, imgUrl, password);
        userRepository.save(user);
    }
}
