package com.smart.module.sys.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import  org.springframework.stereotype.Repository;
import com.smart.module.sys.entity.SysLog;

/**
 * sys_log Repository
*/ 
@Repository 
public interface SysLogRepository extends JpaRepository<SysLog, Long> {
}

