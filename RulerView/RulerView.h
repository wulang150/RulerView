//
//  RulerView.h
//  ChangeDirection
//
//  Created by  Tmac on 16/4/18.
//  Copyright © 2016年 Tmac. All rights reserved.
//
//标尺选择控件
#import <UIKit/UIKit.h>

@interface RulerView : UIView
/*
 value:初始化步数，使用默认数值
 */
- (id)initWithValue:(NSString *)value frame:(CGRect)frame;
/*
 
 dataArr:设置初始化的数据，设置nil使用默认数据
 */
- (id)initWithValue:(NSString *)value frame:(CGRect)frame dataArr:(NSArray *)dataArr;

//返回选中的步数
@property (nonatomic,strong) void(^callBack)(NSString *ret);
@end
