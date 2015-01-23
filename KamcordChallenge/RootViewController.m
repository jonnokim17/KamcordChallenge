//
//  ViewController.m
//  KamcordChallenge
//
//  Created by Jonathan Kim on 1/22/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

#import "RootViewController.h"
#import "CustomTableViewCell.h"
#import "Video.h"

@import MediaPlayer;

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *videosArray;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Video retrieveVideoInformationWithCompletion:^(NSArray *videos) {
        self.videosArray = videos;
    }];
}

-(void)setVideosArray:(NSArray *)videosArray
{
    _videosArray = videosArray;
    [self.tableView reloadData];

}

#pragma mark - Tableview Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videosArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];

    Video *video = self.videosArray[indexPath.row];

    UIImage *thumbnailImage = [UIImage imageWithData:video.thumbnailImageData];
    cell.thumbnailImageView.image = thumbnailImage;
    cell.titleLabel.text = video.title;
    cell.usernameLabel.text = [NSString stringWithFormat:@"By: %@", video.username];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    cell.uploadTime.text = [NSString stringWithFormat:@"Upload Date: %@", [formatter stringFromDate:video.uploadTime]];
    
    cell.viewsLabel.text = [NSString stringWithFormat:@"%@ Views", video.views];
    cell.likesLabel.text = [NSString stringWithFormat:@"%@ Likes", video.likes];
    cell.durationLabel.text = video.duration;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = self.videosArray[indexPath.row];
    NSURL *videoURL = [NSURL URLWithString:video.videoURLString];

    MPMoviePlayerViewController *videoPlayer = [[MPMoviePlayerViewController alloc] init];

    videoPlayer = [[MPMoviePlayerViewController alloc] init];
    videoPlayer.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    [videoPlayer.moviePlayer setContentURL:videoURL];

    [self presentViewController:videoPlayer
                       animated:YES
                     completion:nil];
}

@end
