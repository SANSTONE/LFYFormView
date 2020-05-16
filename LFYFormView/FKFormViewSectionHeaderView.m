//
//  FKFormViewFieldSectionHeaderView.m
//  FDKK
//
//  Created by lei.FY on 2019/8/12.
//  Copyright © 2019 4dage. All rights reserved.
//

#import "FKFormViewSectionHeaderView.h"


@implementation FKFormViewSectionHeaderView

#pragma mark - Init

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
}

- (void)setupSubviews {
   
    self.contentView.backgroundColor = FK_BACKBROUND_COLOR;
    [self addTitleLabel];
}

#pragma mark - Helper Methods


// 添加TitleLabel
- (void)addTitleLabel {
    
    // add
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:titleLabel];
    
    // setup
    titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor whiteColor];
    
    // layout
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.lessThanOrEqualTo(self.contentView).offset(0);
        make.centerY.equalTo(self.contentView).with.offset(8);
    }];
    
    self.titleLabel = titleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
