//
//  ViewController.m
//  RulerView
//
//  Created by  Tmac on 16/6/24.
//  Copyright © 2016年 Tmac. All rights reserved.
//

#import "ViewController.h"
#import "RulerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, width, 22)];
    lab1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab1];
    //使用默认数据
    RulerView *ruler1 = [[RulerView alloc] initWithValue:@"3000" frame:CGRectMake(10, CGRectGetMaxY(lab1.frame)+10, width-20, 80)];
    [self.view addSubview:ruler1];
    ruler1.callBack = ^(NSString *ret){
      
        lab1.text = ret;
    };
    
    
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ruler1.frame)+20, width, 22)];
    lab2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab2];
    
    //自定义数据，每一个单位分成10分
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:100];
    for(int i=0;i<100;i++)
    {
        [dataArr addObject:[NSString stringWithFormat:@"%d",i*100]];
    }
    RulerView *ruler2 = [[RulerView alloc] initWithValue:@"4000" frame:CGRectMake(0, CGRectGetMaxY(lab2.frame)+10, width, 80) dataArr:dataArr];
    [self.view addSubview:ruler2];
    ruler2.callBack = ^(NSString *ret){
        
        lab2.text = ret;
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
