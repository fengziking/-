//
//  ViewController.m
//  FormatterDemo
//
//  Created by 刘建明 on 17/3/15.
//  Copyright © 2017年 刘建明. All rights reserved.
//

#import "ViewController.h"
#import "QTDate.h"
@interface ViewController ()
{
    QTDate *_QTDate;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *dateArray = [QTDate dates];
    //获取当前网络时间。得到7天后年与日及周几
    for (int i = 0; i<dateArray.count ; i++ ) {
        _QTDate = dateArray[i];
        NSLog(@"%@----%@-----%@",_QTDate.month,_QTDate.day,_QTDate.weekday);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
