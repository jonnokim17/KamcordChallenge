//
//  Video.m
//  KamcordChallenge
//
//  Created by Jonathan Kim on 1/22/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

#import "Video.h"

#define kKamcord @"https://www.kamcord.com/app/v2/videos/feed/?feed_id=0"

@implementation Video

- (instancetype)initWithDictionary:(NSDictionary *)videoInfo
{
    self = [super init];

    if (self)
    {
        NSString *imageURLString = videoInfo[@"thumbnails"][@"REGULAR"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        self.thumbnailImageData = [NSData dataWithContentsOfURL:imageURL];

        self.title = videoInfo[@"title"];
        self.username = videoInfo[@"username"];
        self.uploadTime = [Video dateFromNumber:videoInfo[@"upload_time"]];
        self.views = videoInfo[@"interaction_counts"][@"views"];
        self.likes = videoInfo[@"interaction_counts"][@"likes"];
        self.duration = [Video durationFromNumber:videoInfo[@"duration"]];
        self.videoURLString = videoInfo[@"video_url"];
    }

    return self;
}

+ (void)retrieveVideoInformationWithCompletion:(void(^)(NSArray *))complete
{
    NSURL *url = [NSURL URLWithString:kKamcord];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                 options:0
                                                                                                   error:nil];
                               NSArray *resultsArray = resultsDictionary[@"response"][@"video_list"];

                               NSMutableArray *videoArray = [@[] mutableCopy];

                               for (NSDictionary *dict in resultsArray)
                               {
                                   Video *video = [[Video alloc] initWithDictionary:dict];
                                   [videoArray addObject:video];
                               }
                               complete(videoArray);
                           }];
}

+ (NSDate *)dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue])];
    NSTimeInterval interval = [time doubleValue];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000.];
    
    return date;
}

+ (NSString *)durationFromNumber:(NSNumber *)number
{
    NSString *duration;

    NSNumber *time = [NSNumber numberWithInt:([number intValue])];
    int timeInInt = [time intValue];

    if (timeInInt < 10)
    {
        duration = [NSString stringWithFormat:@"0:0%d", timeInInt];
    }
    else if (timeInInt < 60)
    {
        duration = [NSString stringWithFormat:@"0:%d", timeInInt];
    }
    else if (timeInInt > 60)
    {
        int timeInMinutes = timeInInt / 60;
        duration = [NSString stringWithFormat:@">%d min", timeInMinutes];
    }

    return duration;
}


@end
