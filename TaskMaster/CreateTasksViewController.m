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
    Entity *newEntity = [[Entity alloc] initWithContext: self.managedObjectContext];
    newEntity.title = _nameTextField.text;
    newEntity.notes = _notesTextField.text;
    newEntity.completed = NO;
    
    // Save the managed object context
    NSError *saveError = nil;
    if (![self.managedObjectContext save:&saveError]) {
        NSLog(@"Error saving context: %@", saveError);
    } else {
        // Dismiss the add task view controller
        [self.navigationController popViewControllerAnimated:YES];
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
