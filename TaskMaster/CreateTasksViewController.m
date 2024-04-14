//
//  CreateTasksViewController.m
//  TaskMaster
//
//  Created by Jonathan Steele on 4/11/24.
//

#import "CreateTasksViewController.h"
#import "Entity+CoreDataClass.h"
#import "AppDelegate.h"

@interface CreateTasksViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@end

@implementation CreateTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Access the persistent container from the AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSPersistentContainer *persistentContainer = appDelegate.persistentContainer;
    
    // Obtain the managed object context
    self.managedObjectContext = persistentContainer.viewContext;
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    // Create a new Entity object and initialize it with the managed object context
    Entity *newEntity = [[Entity alloc] initWithContext: self.managedObjectContext];
    
    // Set properties of the new Entity object based on user input
    newEntity.title = _nameTextField.text;
    newEntity.notes = _notesTextField.text;
    newEntity.completed = NO;
    
    // Check if there are any changes in the managed object context
    if ([self.managedObjectContext hasChanges]) {
        // Save the managed object context
        NSError *saveError = nil;
        if (![self.managedObjectContext save:&saveError]) {
            // Handle error if saving fails
            NSLog(@"Error saving context: %@", saveError);
        } else {
            // If saving succeeds, dismiss the add task view controller
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
