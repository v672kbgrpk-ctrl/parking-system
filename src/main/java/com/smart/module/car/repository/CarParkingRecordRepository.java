package com.smart.module.car.repository;

import com.smart.module.car.entity.CarParkingRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CarParkingRecordRepository extends JpaRepository<CarParkingRecord, Long> {

    /**
     * 获取最近20条停车记录（按入场时间倒序）
     */
    List<CarParkingRecord> findTop20ByOrderByGmtIntoDesc();
}
