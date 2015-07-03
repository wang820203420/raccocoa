//
//  ViewController.m
//  raccocoa
//
//  Created by wangqian on 6/6/15.
//  Copyright (c) 2015 wangqian. All rights reserved.
//

#import "ViewController.h"
#import "RWDummySigninService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()
{
    UITextField *_text;
    
    
    UITextField *_User;
    UITextField *_Code;
    
    UIButton *_sig;
    
  
    
}
@property(strong,nonatomic) RWDummySigninService *signInService;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    
//    _text = [[UITextField alloc]init];
//    _text.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:_text];
    
//
//    [_text.rac_textSignal subscribeNext:^(id x) {
//    
//        NSLog(@"%@",x);
//    }];
    
    
    
    //过滤:filter(应付复杂的情况)
    //rac_textSignal: 是RAC为UITextField添加的category，只要usernameTextField的值有变化，这个值就会被返回(sendNext)－－－－－－－创建并返回一个信号的文本字段
    //subscribeNext:   加了下面这段代码后，signal就处于Hot的状态了，block里的代码就会被执行。如果不加就处于cold阶段，什么也不会发生。
    [[_text.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length >3;
        
    }]subscribeNext:^(id x) {
        NSLog(@"%@",x);
        
    }];
    ;
    
    
    
    //映射－－－将NSString 映射为NSNumber
    //新添加的map操作使用提供的block来转换事件数据。对于收到的每一个next事件，都会运行给定的block，并将返回值作为next事件发送。在上面的代码中，map操作获取一个NSString输入，并将其映射为一个NSNumber对象，并返回。
//    [[[_text.rac_textSignal map:^id(NSString *text) {
//        
//        return @(text.length);
//    }]
//    filter:^BOOL(NSNumber *length) {
//        return [length intValue] >3;
//    }]
//    subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    
    
        _User = [[UITextField alloc]init];
    
        _User.frame = CGRectMake(100, 100, 100,30);
    
    _User.borderStyle = UITextBorderStyleLine;
   
        [self.view addSubview:_User];
    
    
    
    _Code = [[UITextField alloc]init];
    
    _Code.frame = CGRectMake(100, 150, 100,30);
    
    _Code.borderStyle = UITextBorderStyleLine;
 
    [self.view addSubview:_Code];
    
    
    _sig = [UIButton buttonWithType:UIButtonTypeCustom];
    _sig.frame = CGRectMake(100, 250, 50, 30);
    _sig.backgroundColor = [UIColor redColor];
    [self.view addSubview:_sig];
    
    
    
    //对每个输入框的rac_textSignal应用了一个map(映射成NSNumber)转换。输出是一个用NSNumber封装的布尔值。然后利用收到的值来改变颜色
    RACSignal *validUsernameSignal = [_User.rac_textSignal map:^id(NSString *text) {
        //return @([self isValidUsername:text]);
        return nil;
    
    }];
    
    RACSignal *validPasswordSignal = [_Code.rac_textSignal map:^id(NSString *text) {
        //return @([self isValidPassword:text]);
        
        return nil;
      
    }];
    
    
    //一种方法
//    [[validPasswordSignal map:^id(NSNumber *passwordvalid) {
//        return [passwordvalid boolValue] ?[UIColor clearColor]:[UIColor yellowColor];
//        
//    }] subscribeNext:^(UIColor *color) {
//        _Code.backgroundColor = color;
//    }];
    
    //这是更好的写法
    RAC(_Code,backgroundColor) = [validPasswordSignal map:^id(NSNumber  *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
        
    }];
    
    
    //下一步是转换这些信号，从而能为输入框设置不同的背景颜色。基本上就是，你订阅这些信号，然后用接收到的值来更新输入框的背景颜色
    //RAC宏允许直接把信号的输出应用到对象的属性上。RAC宏有两个参数，第一个是需要设置属性值（NILVALUE）的对象，第二个是属性名（TARGET）。每次信号产生一个next事件，传递过来的值都会应用到该属性上。
    //RAC_(TARGET, KEYPATH, NILVALUE)
    //这个宏是最常用的，RAC()总是出现在等号左边，等号右边是一个RACSignal，表示的意义是将一个对象的一个属性和一个signal绑定，signal每产生一个value（id类型），都会自动执行
    RAC(_User,backgroundColor) = [validUsernameSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    
    
    
    //组合信号
    //使用了combineLatest:reduce:方法来组合validUsernameSignal与validPasswordSignal最后输出的值，并生成一个新的信号。每次两个源信号中的一个输出新值时，reduce块都会被执行，而返回的值会作为组合信号的下一个值。
    
    //注意：RACSignal组合方法可以组合任何数量的信号，而reduce块的参数会对应每一个信号。
    
    RACSignal *signUpActiveSignal = [RACSignal  combineLatest:@[validUsernameSignal,validPasswordSignal ] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        
        return @([usernameValid boolValue] && [passwordValid boolValue]);

    
    }];
    
    
    //这将信号连接到按钮的enabled属性。处于hot状态
//     [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
//        
//         _sig.enabled = [signupActive boolValue];
//         
//         NSLog(@"11");
//     }];
    
    
    
    
    //从按钮的UIControlEventTouchUpInside事件中创建一个信号，并添加订阅以在每次事件发生时添加日志。
//    [[_sig rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        NSLog(@"Button clicked");
//    }];
    
    
    //使用map方法将按钮点击信号转换为登录信号。订阅者简单输出了结果。
    [[[_sig rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(id x) {
        
        NSLog(@"Sign in result: %@", x);
    }];






}


-(RACSignal *)signInSignal
{
    //createSignal:方法用于创建一个信号。描述信号的block是一个信号参数，当信号有一个订阅者时，block中的代码会被执行。
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [self.signInService signInWithUsername:_User.text password:_Code.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
            
        }];
        
        
        return nil;
        
        
    }];
    
}







@end
