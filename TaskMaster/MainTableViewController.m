//
//  ViewController.m
//  TaskMaster
//
//  Created by Jonathan Steele on 4/11/24.
//

#import "MainTableViewController.h"
#import "Entity+CoreDataClass.h"
#import "AppDelegate.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray<Entity *> *tasks;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Access the persistent container from the AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPersistentContainer *persistentContainer = appDelegate.persistentContainer;
    
    // Obtain the managed object context
    self.managedObjectContext = persistentContainer.viewContext;
    
    [self loadTasks];
}

- (void)loadTasks {
    NSFetchRequest *fetchRequest = [Entity fetchRequest];
    NSError *error = nil;
    NSArray *fetchedTasks = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error fetching tasks: %@", error);
    } else {
        self.tasks = [fetchedTasks mutableCopy];
        [self.tableView reloadData];
    }
}

- (IBAction)editButtonTapped:(UIBarButtonItem *)sender {
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
    sender.title = isEditing ? @"Edit" : @"Done";
}

- (IBAction)checkmarkTapped:(UITapGestureRecognizer *)sender {
    // Get the location of the tap gesture in the table view
    CGPoint touchPoint = [sender locationInView:self.tableView];
    
    // Get the index path of the cell at the tap location
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
    
    // Check if the index path is valid
    if (indexPath != nil) {
        // Retrieve the task entity associated with the tapped cell
        Entity *entity = self.tasks[indexPath.row];
        
        // Toggle the completion status of the task
        entity.completed = !entity.completed;
        
        // Check if there are any changes in the managed object context
        if ([self.managedObjectContext hasChanges]) {
            // Save the changes to Core Data
            NSError *saveError = nil;
            if (![self.managedObjectContext save:&saveError]) {
                // Handle error if saving fails
                NSLog(@"Error saving context: %@", saveError);
            } else {
                // Reload the table view to reflect the changes
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainListCell" forIndexPath:indexPath];
    Entity *entity = self.tasks[indexPath.row];
    cell.imageView.image = entity.completed ? [UIImage systemImageNamed:@"checkmark.circle.fill"] : [UIImage systemImageNamed:@"circle"];
    cell.textLabel.text = entity.title;
    cell.detailTextLabel.text = entity.notes;
    return cell;
}

@end
