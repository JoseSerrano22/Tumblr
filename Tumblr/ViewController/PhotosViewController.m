//
//  PhotosViewController.m
//  Tumblr
//
//  Created by jose1009 on 6/24/21.
//

#import "PhotosViewController.h"
#import "PhotosCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *PhotoTableView;


@end

@implementation PhotosViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.PhotoTableView.dataSource = self;
    self.PhotoTableView.delegate = self;
    
//    self.PhotoTableView.rowHeight = 240;
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                
                // Get the dictionary from the response key
                NSDictionary *responseDictionary = dataDictionary[@"response"];
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary[@"posts"];
                NSLog(@"%d", _posts.count);
                [self.PhotoTableView reloadData];

                // TODO: Get the posts and store in posts property
                // TODO: Reload the table view
            }
        }];
    [task resume];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count; //check how many rows
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotosCell" forIndexPath:indexPath];
    
    
    NSDictionary *post = self.posts[indexPath.row];
    
    NSArray *photos = post[@"photos"];
   
    
    if (photos) {
        // 1. Get the first photo in the photos array
        NSDictionary *photo = photos[0];

        // 2. Get the original size dictionary from the photo
        NSDictionary *originalSize =  photo[@"original_size"];
        
        
        
        NSString *width = originalSize[@"width"];
        NSString *height = originalSize[@"height"];
        
        if([width isEqual:height]){
            
            // 3. Get the url string from the original size dictionary
        NSString *urlString = originalSize[@"url"];

            // 4. Create a URL using the urlString
        NSURL *url = [NSURL URLWithString:urlString];
            
        cell.photosImageView.image = nil;
        [cell.photosImageView setImageWithURL:url];
        }
        
    

      
    }
    
    return cell;
}

//-(void)sortImage {
//    for(NSDictionary *post in self.posts){
//        for(NSDictionary *post2 in self.posts){
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
