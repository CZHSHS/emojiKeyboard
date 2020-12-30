//
//  EmojiView.h
//  emojiKeybord
//
//  Created by 陈朝晖 on 2020/12/22.
//  Copyright © 2020 陈朝晖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiView : UIView
@property(nonatomic,copy)void(^emojiInputBlock)(NSString *emojiStr);
@end

NS_ASSUME_NONNULL_END
