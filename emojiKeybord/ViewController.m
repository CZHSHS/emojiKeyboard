//
//  ViewController.m
//  emojiKeybord
//
//  Created by 陈朝晖 on 2020/12/22.
//  Copyright © 2020 陈朝晖. All rights reserved.
//

#import "ViewController.h"
#import "EmojiView.h"
#define  kscreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()<UITextViewDelegate>
@property(nonatomic,strong)EmojiView *emojiInputView;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIButton *emojiBtn;
@property(nonatomic,assign)BOOL isEmoji;
@property(nonatomic,copy)NSString *inputEmoji_str;
@property(nonatomic)NSRange textRange;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isEmoji = NO;
    self.textRange = NSMakeRange(0, 0);
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(100, CGRectGetHeight(self.view.frame) - 30 - 34, 200, 30)];
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    
    self.emojiBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.emojiBtn setTitle:@"表情" forState:UIControlStateNormal];
    self.emojiBtn.backgroundColor =[UIColor grayColor];
    [self.view addSubview:self.emojiBtn];
    [self.emojiBtn addTarget:self action:@selector(imageViewTap) forControlEvents:UIControlEventTouchUpInside];
    self.emojiInputView = [[EmojiView alloc]initWithFrame:CGRectMake(0, 0, kscreenWidth, 200)];
    self.emojiInputView.emojiInputBlock = ^(NSString * _Nonnull emojiStr) {
        self.inputEmoji_str = emojiStr;
        if (self.inputEmoji_str.length > 0) {
            NSString * str = @"";
            NSString * endStr = @"";
            str = [self.textView.text substringWithRange:NSMakeRange(0, self.textRange.location)];
            endStr = [self.textView.text substringWithRange:NSMakeRange(self.textRange.location, self.textView.text.length- self.textRange.location)];
            NSLog(@"str %@",str);
            NSLog(@"endStr %@",endStr);
            self.textView.text = [NSString stringWithFormat:@"%@%@%@",str,self.inputEmoji_str,endStr];
            NSLog(@"textviewStr %@",self.textView.text);
            
            NSRange range = NSMakeRange([NSString stringWithFormat:@"%@%@",str,self.inputEmoji_str].length, 0);
            UITextPosition *start = [self.textView positionFromPosition:[self.textView beginningOfDocument] offset:range.location];
            UITextPosition *end = [self.textView positionFromPosition:start offset:range.length];
            [self.textView setSelectedTextRange:[self.textView textRangeFromPosition:start toPosition:end]];
            self.inputEmoji_str = @"";
        }
    };
    
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
     
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"键盘出现 高度 %d  时间-- %f",height,duration);
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = CGRectMake(100, CGRectGetHeight(self.view.frame) - 30 - 34 - height, 200, 30);
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
   NSLog(@"键盘退出 高度 %d  时间-- %f",height,duration);
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = CGRectMake(100, CGRectGetHeight(self.view.frame) - 30 - 34, 200, 30);
    }];
}


-(void)imageViewTap{
//    if (![_publishContent isFirstResponder]) {
//        return;
//    }
    if (self.isEmoji == NO) {
        self.isEmoji = YES;
        //呼出表情
        self.textView.inputView = self.emojiInputView;
        [self.textView reloadInputViews];
        [self.textView becomeFirstResponder];
    }else{
        self.isEmoji = NO;
        self.textView.inputView=nil;
        [self.textView reloadInputViews];
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView{
    self.textRange = textView.selectedRange;
    
    
    NSLog(@"location - %ld length -- %ld",self.textRange.location,self.textRange.length);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.isEmoji = NO;
    self.textView.inputView=nil;
    [self.textView reloadInputViews];
}

@end
