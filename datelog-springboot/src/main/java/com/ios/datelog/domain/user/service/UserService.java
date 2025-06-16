package com.ios.datelog.domain.user.service;

import com.ios.datelog.domain.user.entity.User;
import com.ios.datelog.domain.user.exception.UserAlreadyExistException;
import com.ios.datelog.domain.user.repository.UserRepository;
import com.ios.datelog.domain.user.web.dto.SignUpReq;
import com.ios.datelog.global.external.exception.FileUploadFailedException;
import com.ios.datelog.global.external.s3.S3Service;
import lombok.RequiredArgsConstructor;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final S3Service s3Service;

    @Transactional
    public void signUp(SignUpReq signUpReq) {
        if(userRepository.findByNickname(signUpReq.nickname()).isPresent()|| userRepository.findByEmail(signUpReq.email()).isPresent()){
            throw new UserAlreadyExistException();
        }

        String imgUrl = null;
        if(signUpReq.profileImage() != null){
            try {
                imgUrl = s3Service.uploadFile(signUpReq.profileImage());
            } catch (IOException e) {
                throw new FileUploadFailedException();
            }
        }

        String password = bCryptPasswordEncoder.encode(signUpReq.password());
        User user = User.toEntity(signUpReq, imgUrl, password);
        userRepository.save(user);
    }
}
