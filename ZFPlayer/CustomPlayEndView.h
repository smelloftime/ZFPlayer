//
//  PlayEndView.h
//  ActiveLabel
//
//  Created by IMAC on 2019/6/17.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"

@interface ShareItemModel : NSObject
/// 分享按钮title
@property (nonatomic, copy, null_unspecified) NSString *title;
/// 分享按钮图片
@property (nonatomic, strong, nullable) UIImage *icon;
/// 附加标志
@property (nonatomic, copy, null_unspecified) NSString *tag;
- (nonnull instancetype)initWithTitle:(null_unspecified NSString *)title icon:(nullable UIImage *)icon tag:(null_unspecified NSString *)tag;
@end

@interface LineAttributes : NSObject
@property (nonatomic, assign) NSUInteger itemNumberOnLine;
@property (nonatomic, assign) CGPoint firstItemCoordinate;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) int lineNumber;
@end

@interface CustomPlayEndView : UIView
/// 重播按钮
@property (nonatomic, strong, nonnull) UIButton *replayButton;
/// 分享提示标题
@property (nonatomic, strong, nonnull) UILabel *sharePromptLabel;
/// 分享模型
@property (nonatomic, strong, nullable) NSArray<ShareItemModel *> *shareItemsModel;
/// 点击分享项后回调
@property (nonatomic, copy) void (^ _Nullable didTapShareItemBlock)(ShareItemModel * _Nonnull model);
/// 分享项大小
@property (nonatomic, assign) CGSize itemSize;
/// 分享项之间的间隔
@property (nonatomic, assign) CGFloat itemSpacing;
/// 分享按钮图标和标题的间距
@property (nonatomic, assign) CGFloat imageAndTitleSpacing;
/// 分享项标题字体
@property (nonatomic, strong, nullable) UIFont *itemTitleFont;
/// 分享项标题颜色
@property (nonatomic, strong, nullable) UIColor *itemTitleColor;
/// 分享项图标颜色
@property (nonatomic, strong, nullable) UIColor *imageColor;
@end

