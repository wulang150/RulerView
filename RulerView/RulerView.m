//
//  RulerView.m
//  ChangeDirection
//
//  Created by  Tmac on 16/4/18.
//  Copyright © 2016年 Tmac. All rights reserved.
//

#import "RulerView.h"

@interface RulerView()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *titleArr;
    int cellHeight;
    NSString *value;
    int w,h;
    NSInteger index;
}

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation RulerView

- (id)initWithValue:(NSString *)val frame:(CGRect)frame
{
    //转换为竖向的坐标，所有的操作都是按照竖向的
    w = frame.size.height;
    h = frame.size.width;
    CGRect iframe = frame;
    iframe.size.width = w;
    iframe.size.height = h;
    iframe.origin.y = frame.origin.y + w/2 - h/2;
    iframe.origin.x = frame.origin.x + (h-w)/2;
    if(self = [super initWithFrame:iframe])
    {
        value = val;
        [self initData];
        [self createView];
    }
    
    return self;
}

- (id)initWithValue:(NSString *)val frame:(CGRect)frame dataArr:(NSArray *)dataArr
{
    //转换为竖向的坐标，所有的操作都是按照竖向的
    w = frame.size.height;
    h = frame.size.width;
    CGRect iframe = frame;
    iframe.size.width = w;
    iframe.size.height = h;
    iframe.origin.y = frame.origin.y + w/2 - h/2;
    iframe.origin.x = frame.origin.x + (h-w)/2;
    if(self = [super initWithFrame:iframe])
    {
        titleArr = [dataArr mutableCopy];
        value = val;
        [self initData];
        [self createView];
    }
    
    return self;
}

- (void)initData
{
    cellHeight = 10;    //每个单位标尺间的距离
    index = 0;
    if(titleArr==nil)
    {
        titleArr = [[NSMutableArray alloc] initWithCapacity:210];
        //设置标尺数据
        for(int i=0;i<210;i++)
        {
            NSString *str = [NSString stringWithFormat:@"%d",i*100];
            [titleArr addObject:str];
            
        }
    }
    
    int i = 0;
    for(NSString *str in titleArr)
    {
        if(value&&[str isEqualToString:value])
        {
            index = i;
            break;
        }
        
        i++;
    }
    
    
    index = titleArr.count*50 + index;
    
}

- (void)createView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    
    //上下的边框
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, h)];
    topLine.backgroundColor = [UIColor grayColor];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(w-1, 0, 1, h)];
    bottomLine.backgroundColor = [UIColor grayColor];
    
    [self addSubview:topLine];
    [self addSubview:bottomLine];
    
    [self.layer addSublayer:[self getMidView:CGRectMake(w, h/2-cellHeight/2, cellHeight*2/3, cellHeight)]];
    
    self.transform = CGAffineTransformRotate(self.transform, -M_PI_2);
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
    
    [_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

//红色三角标示符号
- (CAShapeLayer *)getMidView:(CGRect)frame;
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer new];
    
    [path moveToPoint:CGPointMake(frame.origin.x, frame.origin.y)];
    [path addLineToPoint:CGPointMake(w-frame.size.width, frame.origin.y+frame.size.height/2)];
    [path addLineToPoint:CGPointMake(frame.origin.x, frame.origin.y+frame.size.height)];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    layer.lineWidth = 1;
    
    return layer;
}


#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count*100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Rulercell"];
    if (!cell)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Rulercell"];
        cell.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for(UIView *vi in cell.contentView.subviews)
    {
        [vi removeFromSuperview];
    }
    //清除lab数字显示框
    UILabel *lab = [tableView viewWithTag:cell.tag+1000];
    if(lab&&[lab isKindOfClass:[UILabel class]])
    {
        [lab removeFromSuperview];
    }
    
    int wline = w/8;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(w-2*wline, (cellHeight-1)/2, 2*wline, 1)];
    line.backgroundColor = [UIColor grayColor];
    if(indexPath.row%10==0)
    {
        line.frame = CGRectMake(w-5*wline, (cellHeight-1)/2, 5*wline, 1);
        //添加下面显示的数字，得及时清除
        //58就是横着时候的宽度，高度为3*wline
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(3*wline/2-58/2, cellHeight*indexPath.row-(3*wline-cellHeight)/2, 58, 3*wline)];
        numLab.text = [titleArr objectAtIndex:indexPath.row%titleArr.count];
        numLab.tag = cell.tag+1000;
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.textColor = [UIColor grayColor];
        numLab.font = [UIFont systemFontOfSize:3*wline*3/5];
        [tableView addSubview:numLab];
        //numLab.layer.borderWidth = 1;
        numLab.transform = CGAffineTransformRotate(numLab.transform, M_PI_2);
        
        CGPoint center = numLab.center;
        [numLab sizeToFit];
        numLab.center = center;
    }
    
    [cell.contentView addSubview:line];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    
}
//拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        
        [self scrollEnd:scrollView];
    }
}
//滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollEnd:scrollView];
}

- (void)scrollEnd:(UIScrollView *)scrollView
{
    NSIndexPath *path =  [_tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+h/2)];
    
    //NSLog(@"val = %@",[titleArr objectAtIndex:path.row%titleArr.count]);
    
    [_tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    if(self.callBack)
        self.callBack([titleArr objectAtIndex:path.row%titleArr.count]);
}
@end
