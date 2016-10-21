//
//  ViewController.m
//  多图
//
//  Created by lqq on 2016/10/21.
//  Copyright © 2016年 lqq. All rights reserved.
//

#import "ViewController.h"
#import "LQHttpTool.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *mImgs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"上传图片" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(setupData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}


- (void)setupData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [LQHttpTool post:@"url" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //这里是表单
        //利用for循环上传多张图片 self.mImgs:实际项目使用时是从相册选取的结果
        int i = 1;
        for (UIImage * image in self.mImgs) {
            //把图片转换为二进制流
            NSData *imageData = UIImagePNGRepresentation(image);
            //按照表单格式把二进制文件写入formData表单 imgs:看服务端需要,改变此名称
            [formData appendPartWithFileData:imageData name:@"imgs" fileName:[NSString stringWithFormat:@"%d.png", i] mimeType:@"image/png"];
            i++;
            
        }
        
    } success:^(id responseObject) {
        
        NSLog(@"==上传成功=");
    } faliure:^(NSError *error) {
        NSLog(@"==上传失败=");
    }];
}

#pragma mark lazy
-(NSMutableArray *)mImgs {
    if (!_mImgs) {
        _mImgs = [NSMutableArray array];
        
        UIImage *img1 = [UIImage imageNamed:@"test1"];
        [_mImgs addObject:img1];
        UIImage *img2 = [UIImage imageNamed:@"test2"];
        [_mImgs addObject:img2];
        UIImage *img3 = [UIImage imageNamed:@"test3"];
        [_mImgs addObject:img3];
    }
    return _mImgs;
}


@end
