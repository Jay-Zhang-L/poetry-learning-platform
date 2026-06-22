package com.shici.mapper;

import com.shici.domain.dto.map.*;
import org.apache.ibatis.annotations.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * 诗词地图Mapper接口
 */
public interface PoetryMapMapper {

    // ==================== 地图概览相关 ====================

    /**
     * 获取所有地点的热度数据
     */
    List<LocationHeatDto> getLocationHeatData(@Param("dynasty") String dynasty,
                                              @Param("minHeat") BigDecimal minHeat);

    /**
     * 获取地点的著名诗人列表
     */
    List<String> getFamousPoetsByLocation(@Param("locationId") Long locationId,
                                          @Param("dynasty") String dynasty,
                                          @Param("limit") int limit);

    /**
     * 获取全部诗人列表
     */
    List<RepresentativePoetDto> getAllPoets();

    // ==================== 地点详情相关 ====================

    /**
     * 获取地点基本信息
     */
    LocationDetailResponse getLocationById(@Param("id") Long id);

    /**
     * 获取地点的代表诗人
     */
    List<RepresentativePoetDto> getRepresentativePoets(@Param("locationId") Long locationId);

    /**
     * 获取地点的典故列表
     */
    List<AllusionDto> getAllusionsByLocationId(@Param("locationId") Long locationId);

    /**
     * 获取地点的诗词统计（按朝代）
     */
    List<DynastyStatDto> getPoemStatsByLocation(@Param("locationId") Long locationId);

    // ==================== 诗人路线相关 ====================

    /**
     * 获取诗人基本信息
     */
    PoetInfoDto getPoetInfoById(@Param("id") Long id);

    /**
     * 获取诗人路线
     */
    List<RoutePointDto> getPoetRoute(@Param("poetId") Long poetId);

    /**
     * 获取路线上某地点的诗词
     */
    List<RoutePoemDto> getPoemsByPoetAndLocation(@Param("poetId") Long poetId,
                                                  @Param("locationId") Long locationId);

    // ==================== 诗人关系网相关 ====================

    /**
     * 获取诗人关系网节点（包含诗人自身和关联诗人）
     */
    List<RelationNodeDto> getRelationNodes(@Param("poetId") Long poetId);

    /**
     * 获取诗人关系网边
     */
    List<RelationEdgeDto> getRelationEdges(@Param("poetId") Long poetId);

    // ==================== 时间轴相关 ====================

    /**
     * 获取诗人时间轴事件
     */
    List<TimelineEventDto> getTimelineEvents(@Param("poetId") Long poetId);

    // ==================== 典故详情相关 ====================

    /**
     * 获取地点名称
     */
    String getLocationName(@Param("id") Long id);

    /**
     * 获取地点的典故详情（包含相关诗词）
     */
    List<AllusionDetailDto> getAllusionDetailsByLocation(@Param("locationId") Long locationId);

    /**
     * 获取典故相关的诗词
     */
    List<RelatedPoemDto> getRelatedPoemsByAllusion(@Param("allusionId") Long allusionId);

    // ==================== 省份相关 ====================

    /**
     * 获取所有省份列表
     */
    List<ProvinceDto> getAllProvinces();

    /**
     * 根据ID获取省份详情
     */
    ProvinceDetailResponse getProvinceById(@Param("id") Long id);
}
