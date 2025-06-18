package com.ios.datelog.domain.record.repository;

import com.ios.datelog.domain.record.entity.Datelog;
import com.ios.datelog.domain.record.exception.DatelogNotFoundException;
import com.ios.datelog.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DatelogRepository extends JpaRepository<Datelog, Long> {
    List<Datelog> findAllByUser(User user);

    default Datelog getDatelogById(Long id) {
        return this.findById(id).orElseThrow(DatelogNotFoundException::new);
    }
}
