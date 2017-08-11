//
//  KKSegmentCollectionCell.m
//  KKToydayNews
//
//  Created by finger on 2017/8/7.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKSegmentCollectionCell.h"

#define CellFont [UIFont systemFontOfSize:15]

@interface KKSegmentCollectionCell()
@property(nonatomic,strong)UILabel *label ;
@end

@implementation KKSegmentCollectionCell

+ (CGSize)titleSize:(NSString *)title{
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:CellFont} context:nil].size;
    
    return CGSizeMake(size.width + 15, size.height) ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInterface];
    }
    return self;
}

- (void)setUserInterface{
    [self.contentView addSubview:self.label];
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)label{
    if(!_label){
        _label = ({
            UILabel *label = [[UILabel alloc]init];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor blackColor];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = CellFont;
            label;
        });
    }
    return _label ;
}

- (void)setItem:(KKSegmentItem *)item{
    self.label.text = item.title;
}

- (void)setIsSelected:(BOOL)isSelected{
    if(isSelected){
        self.label.textColor = [UIColor redColor];
    }else{
        self.label.textColor = [UIColor blackColor];
    }
}

@end
