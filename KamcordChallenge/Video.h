//
//  Video.h
//  KamcordChallenge
//
//  Created by Jonathan Kim on 1/22/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (strong, nonatomic) NSData    *thumbnailImageData;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *username;
@property (strong, nonatomic) NSDate    *uploadTime;
@property (strong, nonatomic) NSNumber  *views;
@property (strong, nonatomic) NSNumber  *likes;
@property (strong, nonatomic) NSString  *duration;
@property (strong, nonatomic) NSString  *videoURLString;

- (instancetype)initWithDictionary:(NSDictionary *)videoInfo;
+ (void)retrieveVideoInformationWithCompletion:(void(^)(NSArray *))complete;


@end
