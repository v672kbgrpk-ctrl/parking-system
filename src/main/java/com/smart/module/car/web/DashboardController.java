package com.smart.module.car.web;

import com.smart.common.model.Result;
import com.smart.module.car.entity.CarParkingRecord;
import com.smart.module.car.repository.CarParkingRecordRepository;
import com.smart.module.car.repository.ParkManageRepository;
import com.smart.module.finance.entity.Order;
import com.smart.module.finance.repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 数据分析大屏接口
 */
@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private CarParkingRecordRepository carParkingRecordRepository;
    @Autowired
    private ParkManageRepository parkManageRepository;
    @Autowired
    private OrderRepository orderRepository;

    /**
     * 获取今日统计数据
     */
    @GetMapping("/todayStats")
    public Result getTodayStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 今日时间范围
        LocalDate today = LocalDate.now();
        Timestamp startOfDay = Timestamp.valueOf(today.atStartOfDay());
        Timestamp endOfDay = Timestamp.valueOf(today.atTime(LocalTime.MAX));
        
        // 获取所有记录
        List<CarParkingRecord> allRecords = carParkingRecordRepository.findAll();
        List<Order> allOrders = orderRepository.findAll();
        
        // 今日入场车辆数
        long todayInCount = allRecords.stream()
                .filter(r -> r.getGmtInto() != null 
                        && r.getGmtInto().after(startOfDay) 
                        && r.getGmtInto().before(endOfDay))
                .count();
        
        // 今日出场车辆数
        long todayOutCount = allRecords.stream()
                .filter(r -> r.getGmtOut() != null 
                        && r.getGmtOut().after(startOfDay) 
                        && r.getGmtOut().before(endOfDay))
                .count();
        
        // 今日收入
        BigDecimal todayIncome = allOrders.stream()
                .filter(o -> o.getGmtCreate() != null 
                        && o.getGmtCreate().after(startOfDay) 
                        && o.getGmtCreate().before(endOfDay)
                        && o.getTotalFee() != null)
                .map(Order::getTotalFee)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // 停车场总数
        long parkCount = parkManageRepository.count();
        
        // 总车位数
        int totalSpaces = parkManageRepository.findAll().stream()
                .mapToInt(p -> p.getParkingSpaceNumber() != null ? p.getParkingSpaceNumber() : 0)
                .sum();
        
        // 当前在场车辆数（已入场未出场）
        long currentInCount = allRecords.stream()
                .filter(r -> r.getGmtInto() != null && r.getGmtOut() == null)
                .count();
        
        // 车位使用率
        double usageRate = totalSpaces > 0 ? (double) currentInCount / totalSpaces * 100 : 0;
        
        stats.put("todayInCount", todayInCount);
        stats.put("todayOutCount", todayOutCount);
        stats.put("todayIncome", todayIncome);
        stats.put("parkCount", parkCount);
        stats.put("totalSpaces", totalSpaces);
        stats.put("currentInCount", currentInCount);
        stats.put("usageRate", String.format("%.1f", usageRate));
        
        return Result.ok("获取成功", stats);
    }

    /**
     * 获取最近7天收入趋势
     */
    @GetMapping("/incomeTrend")
    public Result getIncomeTrend() {
        List<Map<String, Object>> trend = new ArrayList<>();
        List<Order> allOrders = orderRepository.findAll();
        
        for (int i = 6; i >= 0; i--) {
            LocalDate date = LocalDate.now().minusDays(i);
            Timestamp start = Timestamp.valueOf(date.atStartOfDay());
            Timestamp end = Timestamp.valueOf(date.atTime(LocalTime.MAX));
            
            BigDecimal income = allOrders.stream()
                    .filter(o -> o.getGmtCreate() != null 
                            && o.getGmtCreate().after(start) 
                            && o.getGmtCreate().before(end)
                            && o.getTotalFee() != null)
                    .map(Order::getTotalFee)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            Map<String, Object> dayData = new HashMap<>();
            dayData.put("date", date.toString());
            dayData.put("income", income);
            trend.add(dayData);
        }
        
        return Result.ok("获取成功", trend);
    }

    /**
     * 获取车辆类型分布
     */
    @GetMapping("/carTypeDistribution")
    public Result getCarTypeDistribution() {
        List<CarParkingRecord> allRecords = carParkingRecordRepository.findAll();
        
        Map<Short, Long> typeCount = allRecords.stream()
                .filter(r -> r.getType() != null)
                .collect(Collectors.groupingBy(CarParkingRecord::getType, Collectors.counting()));
        
        List<Map<String, Object>> distribution = new ArrayList<>();
        String[] typeNames = {"包月车", "VIP免费车", "临时车"};
        
        for (int i = 0; i < 3; i++) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", typeNames[i]);
            item.put("value", typeCount.getOrDefault((short) i, 0L));
            distribution.add(item);
        }
        
        return Result.ok("获取成功", distribution);
    }

    /**
     * 获取今日各时段车流量
     */
    @GetMapping("/hourlyTraffic")
    public Result getHourlyTraffic() {
        LocalDate today = LocalDate.now();
        Timestamp startOfDay = Timestamp.valueOf(today.atStartOfDay());
        Timestamp endOfDay = Timestamp.valueOf(today.atTime(LocalTime.MAX));
        
        List<CarParkingRecord> todayRecords = carParkingRecordRepository.findAll().stream()
                .filter(r -> r.getGmtInto() != null 
                        && r.getGmtInto().after(startOfDay) 
                        && r.getGmtInto().before(endOfDay))
                .collect(Collectors.toList());
        
        int[] hourlyData = new int[24];
        for (CarParkingRecord record : todayRecords) {
            int hour = record.getGmtInto().toLocalDateTime().getHour();
            hourlyData[hour]++;
        }
        
        List<Map<String, Object>> result = new ArrayList<>();
        for (int i = 0; i < 24; i++) {
            Map<String, Object> item = new HashMap<>();
            item.put("hour", i + ":00");
            item.put("count", hourlyData[i]);
            result.add(item);
        }
        
        return Result.ok("获取成功", result);
    }

    /**
     * 获取支付方式分布
     */
    @GetMapping("/payTypeDistribution")
    public Result getPayTypeDistribution() {
        List<Order> allOrders = orderRepository.findAll();
        
        Map<Short, Long> typeCount = allOrders.stream()
                .filter(o -> o.getType() != null)
                .collect(Collectors.groupingBy(Order::getType, Collectors.counting()));
        
        List<Map<String, Object>> distribution = new ArrayList<>();
        String[] payTypeNames = {"微信支付", "支付宝", "Apple Pay", "HUAWEI Pay"};
        
        for (int i = 0; i < 4; i++) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", payTypeNames[i]);
            item.put("value", typeCount.getOrDefault((short) i, 0L));
            distribution.add(item);
        }
        
        return Result.ok("获取成功", distribution);
    }
}