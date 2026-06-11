package com.smart.module.car.service.impl;

import com.smart.common.constant.SystemConstant;
import com.smart.common.dynamicquery.DynamicQuery;
import com.smart.common.model.PageBean;
import com.smart.common.model.Result;
import com.smart.common.util.DateUtils;
import com.smart.common.util.ShiroUtils;
import com.smart.module.car.entity.CarParkManage;
import com.smart.module.car.entity.CarParkingRecord;
import com.smart.module.car.repository.ParkManageRepository;
import com.smart.module.car.repository.CarParkingRecordRepository;
import com.smart.module.car.service.ParkManageService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class ParkManageServiceImpl implements ParkManageService {

    @Autowired
    private DynamicQuery dynamicQuery;
    @Autowired
    private ParkManageRepository parkManageRepository;
    @Autowired
    private CarParkingRecordRepository parkingRecordRepository;

    private static final int RECORD_COUNT = 20;
    private static final double HOT_THRESHOLD = 0.5;
    private static final double COLD_THRESHOLD = 0.2;

    @Override
    @Transactional(rollbackFor=Exception.class)
    public Result save(CarParkManage entity) {
        if(entity.getId()==null){
            entity.setGmtCreate(DateUtils.getTimestamp());
            entity.setGmtModified(entity.getGmtCreate());
        }else{
            entity.setGmtModified(DateUtils.getTimestamp());
        }
        parkManageRepository.saveAndFlush(entity);
        return Result.ok("保存成功");
    }

    @Override
    public Result list(CarParkManage entity) {
        String nativeSql = "SELECT COUNT(*) FROM app_car_park_manage ";
        nativeSql += common(entity);
        Long count = dynamicQuery.nativeQueryCount(nativeSql);
        PageBean<Map<String, Object>> data = new PageBean<>();
        if(count>0){
            nativeSql = "SELECT * FROM app_car_park_manage ";
            nativeSql += common(entity);
            nativeSql += "ORDER BY gmt_create desc";
            Pageable pageable = PageRequest.of(entity.getPageNo(),entity.getPageSize());
            List<CarParkManage> list =  dynamicQuery.nativeQueryPagingList(CarParkManage.class,pageable,nativeSql);
            
            Map<Long, Long> parkUsageCount = getParkUsageCount();
            
            List<Map<String, Object>> resultList = list.stream()
                    .map(park -> {
                        Map<String, Object> parkInfo = new HashMap<>();
                        parkInfo.put("id", park.getId());
                        parkInfo.put("name", park.getName());
                        parkInfo.put("parkingSpaceNumber", park.getParkingSpaceNumber());
                        parkInfo.put("status", park.getStatus());
                        parkInfo.put("freeTime", park.getFreeTime());
                        parkInfo.put("timeUnit", park.getTimeUnit());
                        parkInfo.put("unitCost", park.getUnitCost());
                        parkInfo.put("gmtCreate", park.getGmtCreate());
                        
                        long usageCount = parkUsageCount.getOrDefault(park.getId(), 0L);
                        double usageRate = (double) usageCount / RECORD_COUNT;
                        String level = getHeatLevel(usageRate);
                        parkInfo.put("heatLevel", level);
                        parkInfo.put("heatLevelText", getHeatLevelText(level));
                        parkInfo.put("heatIcon", getHeatIcon(level));
                        return parkInfo;
                    })
                    .collect(Collectors.toList());
            
            data = new PageBean<>(resultList, count);
        }
        return Result.ok(data);
    }
    
    private Map<Long, Long> getParkUsageCount() {
        List<CarParkingRecord> records = parkingRecordRepository.findTop20ByOrderByGmtIntoDesc();
        return records.stream()
                .collect(Collectors.groupingBy(CarParkingRecord::getParkManageId, Collectors.counting()));
    }
    
    private String getHeatLevel(double usageRate) {
        if (usageRate >= HOT_THRESHOLD) {
            return "HOT";
        } else if (usageRate >= COLD_THRESHOLD) {
            return "NORMAL";
        } else {
            return "COLD";
        }
    }
    
    private String getHeatLevelText(String level) {
        switch (level) {
            case "HOT":
                return "热门";
            case "NORMAL":
                return "常温";
            case "COLD":
                return "冷门";
            default:
                return "未知";
        }
    }
    
    private String getHeatIcon(String level) {
        switch (level) {
            case "HOT":
                return "🔥";
            case "NORMAL":
                return "🌿";
            case "COLD":
                return "❄️";
            default:
                return "⚪";
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<Map<String,Object>> select(CarParkManage entity) {
        String nativeSql = "SELECT id,name FROM app_car_park_manage WHERE 1=1";
        if(ShiroUtils.isHasRole(SystemConstant.ROLE_ADMIN)){
            if(entity.getOrgId()!=null){
                nativeSql +=" AND org_id="+entity.getOrgId();
            }
        }else{
            Long orgId = ShiroUtils.getUserEntity().getOrgId();
            nativeSql +=" AND org_id="+orgId;
        }
        return dynamicQuery.nativeQueryListMap(nativeSql);
    }

    public String common(CarParkManage entity){
        String description = entity.getDescription();
        String commonSql = "";
        if(StringUtils.isNotBlank(description)){
            commonSql += "WHERE name like '"+description+"%' ";
        }
        return commonSql;
    }

}
