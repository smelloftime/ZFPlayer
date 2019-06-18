//
//  PlayEndView.m
//  ActiveLabel
//
//  Created by IMAC on 2019/6/17.
//

#import "CustomPlayEndView.h"

@implementation ShareItemModel
- (nonnull instancetype)initWithTitle:(null_unspecified NSString *)title icon:(nullable UIImage *)icon tag:(null_unspecified NSString *)tag
{
    self = [super init];
    if (self) {
        _title = title;
        _icon = icon;
        _tag = tag;
    }
    return self;
}
@end

@implementation LineAttributes

@end

@interface CustomPlayEndView()
@property (nonatomic, strong) CAShapeLayer *separatorLayer;
@property (nonatomic, strong) NSMutableArray<UIButton *> *shareItemsButtonArray;
@end

@implementation CustomPlayEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemSize = CGSizeMake(48, 76);
        _imageAndTitleSpacing = 10;
        _itemSpacing = 36;
        _itemTitleFont = [UIFont systemFontOfSize:14];
        _shareItemsButtonArray = [[NSMutableArray alloc] init];
        [self setupView];
        [self setupConstraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat labelWidth = CGRectGetWidth(_sharePromptLabel.frame);
    CGFloat titleWidth = [_sharePromptLabel.text boundingRectWithSize:CGSizeMake(labelWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _sharePromptLabel.font} context:nil].size.width;
    CGFloat lineWidth = (labelWidth - titleWidth - 24) / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGPoint start = CGPointMake(0.0, CGRectGetMidY(_sharePromptLabel.bounds));
    CGPoint end = CGPointMake(lineWidth, start.y);
    [path moveToPoint: start];
    [path addLineToPoint: end];
    start.x = end.x + titleWidth + 24;
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(_sharePromptLabel.bounds), start.y)];
    _separatorLayer.path = path.CGPath;
    [self layoutShareItems];
}

- (void)setupView {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replayButton setImage:ZFPlayerImage(@"ZFPlayer_repeat_video") forState:UIControlStateNormal];
    [self addSubview:_replayButton];
    _sharePromptLabel = [[UILabel alloc] init];
    _sharePromptLabel.text = @"分享至";
    _sharePromptLabel.textColor = [UIColor whiteColor];
    _sharePromptLabel.font = [UIFont systemFontOfSize:20  weight:UIFontWeightSemibold];
    _sharePromptLabel.textAlignment = NSTextAlignmentCenter;
    _separatorLayer = [CAShapeLayer layer];
    _separatorLayer.doubleSided = NO;
    _separatorLayer.strokeColor = [UIColor whiteColor].CGColor;
    _separatorLayer.lineWidth = 1;
    _separatorLayer.fillColor = [UIColor clearColor].CGColor;
    [_sharePromptLabel.layer addSublayer:_separatorLayer];
    [self addSubview:_sharePromptLabel];
}

- (void)setupConstraints {
    [_sharePromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-25);
    }];
    [_replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sharePromptLabel.mas_top).offset(-48);
        make.centerX.equalTo(self);
        make.size.equalTo(@(74));
    }];
}

- (void)setShareItemsModel:(NSArray<ShareItemModel *> *)shareItemsModel {
    _shareItemsModel = shareItemsModel;
    NSUInteger minCount = MIN(shareItemsModel.count, _shareItemsButtonArray.count);
    for (int i = 0; i < minCount; i++) {
        [self congfigShareItem:_shareItemsButtonArray[i] model:shareItemsModel[i]];
    }
    int diff = (int)(shareItemsModel.count - _shareItemsButtonArray.count);
    if (diff > 0) {
        for (NSUInteger i = minCount; diff != 0; diff--, i++) {
            UIButton *button = [[UIButton alloc] init];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.tag = i;
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button addTarget:self action:@selector(shareItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self congfigShareItem:button model:shareItemsModel[i]];
            [self addSubview:button];
            [_shareItemsButtonArray addObject:button];
        }
    } else {
        for (; diff != 0; diff++) {
            [_shareItemsButtonArray.lastObject removeFromSuperview];
            [_shareItemsButtonArray removeLastObject];
        }
    }
}

- (void)congfigShareItem:(UIButton *)item model:(ShareItemModel *)model {
    [item setTitle:model.title forState:UIControlStateNormal];
    [item setTitleColor:_itemTitleColor forState:UIControlStateNormal];
    if (_imageColor) {
        [item setImage:[model.icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    } else {
        [item setImage:model.icon forState:UIControlStateNormal];
    }
    item.tintColor = _imageColor;
    item.titleLabel.font = _itemTitleFont;
    
}

- (NSArray<NSNumber *> *)allTitleWidth {
    NSDictionary *attr = @{NSFontAttributeName: _itemTitleFont};
    CGSize maxTitleSize = CGSizeMake(self.frame.size.width - 2 * _itemSpacing, _itemTitleFont.lineHeight);
    NSMutableArray<NSNumber *> *titlesWidth = [[NSMutableArray alloc] initWithCapacity:_shareItemsModel.count];
    for (ShareItemModel *model in _shareItemsModel) {
        CGFloat width = [model.title boundingRectWithSize:maxTitleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.width;
        [titlesWidth addObject:[NSNumber numberWithFloat:width]];
    }
    return titlesWidth;
}

- (void)layoutShareItems {
    NSArray<NSNumber *> *titlesWidth = [self allTitleWidth];
    CGFloat maxTitleWidth = [(NSNumber *)[titlesWidth valueForKeyPath:@"@max.self"] floatValue];
    CGSize itemSize = CGSizeMake(fmaxf(_itemSize.width, maxTitleWidth), _itemSize.height);
    NSArray<LineAttributes *> *lineAttrs = [self getLineAttributesByItemCount:(int)_shareItemsButtonArray.count itemSize:itemSize interitemSpacing:_itemSpacing lineSpacing:0];
    int index = 0;
    for (LineAttributes *attr in lineAttrs) {
        for (int i = 0; i < attr.itemNumberOnLine; i++) {
            UIButton *btn = _shareItemsButtonArray[i + index];
            btn.frame = CGRectMake(attr.firstItemCoordinate.x + i * (itemSize.width + _itemSpacing), attr.firstItemCoordinate.y, itemSize.width, itemSize.height);
            CGFloat imageTop = (CGRectGetHeight(btn.frame) - CGRectGetHeight(btn.imageView.frame) - CGRectGetHeight(btn.titleLabel.frame) - _imageAndTitleSpacing) / 2;
            CGFloat titleTop = imageTop + _imageAndTitleSpacing + CGRectGetHeight(btn.imageView.frame);
            CGFloat imageLeft = (CGRectGetWidth(btn.frame) - CGRectGetWidth(btn.imageView.frame)) / 2;
            CGFloat titleLeft = (CGRectGetWidth(btn.frame) - [titlesWidth[i + index] floatValue]) / 2 - CGRectGetWidth(btn.imageView.frame);
            btn.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft, 0.0, 0.0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, 0.0, 0.0);
        }
        index += attr.itemNumberOnLine;
    }
}

- (void)shareItemAction:(UIButton *)btn {
    if (_didTapShareItemBlock && btn.tag < _shareItemsModel.count) {
        self.didTapShareItemBlock(self.shareItemsModel[btn.tag]);
    }
}

- (NSArray<LineAttributes *> *)getLineAttributesByItemCount:(int)count
                                        itemSize:(CGSize)itemSize
                             interitemSpacing:(CGFloat)interitemSpacing
                                                lineSpacing:(CGFloat)lineSpacing {
    NSMutableArray<LineAttributes *> *lineAttrs = [[NSMutableArray alloc] init];
    CGFloat firstLineY = CGRectGetMaxY(_sharePromptLabel.frame) + 48;
    int maxItemNumberOnLine = (self.frame.size.width - interitemSpacing) / (itemSize.width + interitemSpacing);
    CGFloat firstItemX = (self.frame.size.width - maxItemNumberOnLine * (itemSize.width + interitemSpacing) + interitemSpacing) / 2.0;
    int lineNumber = ceil((CGFloat)count / maxItemNumberOnLine);
    for (int i = 0; i < lineNumber;) {
        LineAttributes *attr = [[LineAttributes alloc] init];
        attr.itemNumberOnLine = maxItemNumberOnLine;
        attr.firstItemCoordinate = CGPointMake(firstItemX, firstLineY + i * (itemSize.height + lineSpacing));
        attr.interitemSpacing = interitemSpacing;
        attr.lineNumber = ++i;
        [lineAttrs addObject:attr];
    }
    LineAttributes *lastLineAttr = lineAttrs.lastObject;
    if (lastLineAttr) {
        lastLineAttr.itemNumberOnLine = count - (lineNumber - 1) * maxItemNumberOnLine;
        lastLineAttr.firstItemCoordinate = CGPointMake((self.frame.size.width - lastLineAttr.itemNumberOnLine * (itemSize.width + interitemSpacing) + interitemSpacing) / 2.0, lastLineAttr.firstItemCoordinate.y);
    }
    return  lineAttrs;
}

@end
