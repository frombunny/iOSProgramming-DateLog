package com.ios.datelog.domain.record.repository;

import com.ios.datelog.domain.record.entity.Datelog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DatelogRepository extends JpaRepository<Datelog, Long> {
}
