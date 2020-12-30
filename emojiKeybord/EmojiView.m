//
//  EmojiView.m
//  emojiKeybord
//
//  Created by 陈朝晖 on 2020/12/22.
//  Copyright © 2020 陈朝晖. All rights reserved.
//

#import "EmojiView.h"
#define  kscreenWidth [UIScreen mainScreen].bounds.size.width
@interface EmojiView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIPageControl *pageControlBottom;
@property(nonatomic,strong)UICollectionView *scrollView;

@end

@implementation EmojiView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
        [self creatDataSource];
    }
    return self;
}
-(void)creatDataSource{
    self.dataArray = [NSMutableArray new];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojisList" ofType:@"plist"];
    //当数据结构为数组时
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * arr = dictionary[@"People"];
    [self.dataArray setArray:arr];
    
    [self.scrollView reloadData];
}
-(void)creatUI{
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 200)];
    [self addSubview:self.bgView];
    self.pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 170,kscreenWidth , 20)];
    [self.bgView addSubview:self.pageControlBottom];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情按钮的大小为30*30
    layout.itemSize=CGSizeMake(30, 30);
    //设置分区的内容偏移
    layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160) collectionViewLayout:layout];
    //打开分页效果
    self.scrollView.pagingEnabled = YES;
    //设置行列间距
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=5;
    
    self.scrollView.delegate=self;
    self.scrollView.dataSource=self;
    self.scrollView.backgroundColor = self.bgView.backgroundColor;
    [self.bgView addSubview:self.scrollView];
    [self.scrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"biaoqing"];
    
    
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return (self.dataArray.count/28)+(self.dataArray.count%28==0?0:1);
//}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (((self.dataArray.count/28)+(self.dataArray.count%28==0?0:1))!=section+1) {
//         return 28;
//    }else{
//        return self.dataArray.count-28*((self.dataArray.count/28)+(self.dataArray.count%28==0?0:1)-1);
//    }
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"biaoqing" forIndexPath:indexPath];
    for (int i=(int)cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.font = [UIFont systemFontOfSize:25];
    label.text = self.dataArray[indexPath.row+indexPath.section*28] ;
    [cell.contentView addSubview:label];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = self.dataArray[indexPath.section*28+indexPath.row];
    //这里手动将表情符号添加到textField上
    if (self.emojiInputBlock) {
        self.emojiInputBlock(str);
    }
}
//翻页后对分页控制器进行更新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    self.pageControlBottom.currentPage = page;
 
}

@end
