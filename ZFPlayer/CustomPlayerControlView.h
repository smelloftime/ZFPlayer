//
//  CustomPlayerControlView.h
//  Player
//
//  Created by lip on 2018/4/8.
//  Copyright © 2018年 任子丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "CustomPlayEndView.h"

@interface PlayerControlViewConfig : NSObject
@property (nonatomic, strong, nullable) UIImage *fullScreenImage;
@property (nonatomic, strong, nullable) UIImage *shrinkScreenImage;
@property (nonatomic, strong, nullable) UIColor *minimumTrackTintColor;
@property (nonatomic, strong, nullable) UIColor *maximumTrackTintColor;
@property (nonatomic, strong, nullable) UIColor *timeLabelColor;
@property (nonatomic, assign) CGFloat bottomViewHeight;
@property (nonatomic, assign) CGFloat bottomViewHeightOnFullScreenImage;
@end

@interface CustomPlayerControlView : UIView
/// 进度条已经播放的颜色
@property (strong, nonatomic) UIColor *minimumTrackTintColor;
/// 是否显示重播和分享按钮, 默认显示
@property (nonatomic, assign) BOOL hiddenReplayAndShareBtn;
/// 是否隐藏全屏按钮, 默认显示
@property (nonatomic, assign) BOOL hiddenFullScreenBtn;
/// 是否隐藏返回按钮, 默认全屏下显示
@property (nonatomic, assign) BOOL hiddenBackBtn;
/// 是否总是隐藏控制层(默认自动隐藏和显示) [隐藏控制层UI,只接收相关代理回调]
@property (nonatomic) BOOL alwaysHiddenControlUI;
/// 全屏播放结束后是否显示分享界面
@property (nonatomic, assign) BOOL showFullScreenPlayEndView;
/// 全屏播放结束后分享界面
@property (nonatomic, strong, null_resettable) CustomPlayEndView *fullScreenPlayEndView;
/// [回调] 播放完毕回调属性
@property (nonatomic, copy) void(^ _Nullable zf_playerPlayEndBlock)();

@property (nonatomic, strong, nullable) PlayerControlViewConfig *controlViewConfig;

/// [回调] 播放完毕
- (void)zf_playerPlayEnd;
/// [回调] 控制视图消失
- (void)didHiddenControlView;
/// 重置控制视图, 需要隐藏重播按钮、分享按钮就在复写
- (void)zf_playerResetControlView;

/// 显示控制视图
- (void)showControlView;

/// 重播视频, 可以复写比如重播默认不显示控制视图
- (void)replayVideo:(UIButton *)sender;

/// 更新loading素材
- (void)uploadLoadingImages:(NSArray*)images;
/// 隐藏顶部阴影
- (void)setTopMaskLayerImage:(UIImage*) image;
/// 隐藏底部阴影
- (void)setBottomMaskLayerImage:(UIImage*) image;
/// 设置loading背景颜色
- (void)uploadLoadingBackGroundColor:(UIColor*)color;
/// 设置分享模型和点击回调
- (void)setFullScreenShareItemsModel:(nullable NSArray<ShareItemModel *> *)itemsModel didSelectedItemBlock:(void (^ _Nullable)(ShareItemModel * _Nonnull))didSelectedItemBlock;
/// 设置是否全屏
- (void)setPlayerFullScreen:(BOOL)fullScreen;

- (instancetype)init;
@end
