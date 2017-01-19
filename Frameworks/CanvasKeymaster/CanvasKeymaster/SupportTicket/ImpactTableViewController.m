//
//  ImpactTableViewController.m
//  iCanvas
//
//  Created by Rick Roberts on 8/22/14.
//  Copyright (c) 2014 Instructure. All rights reserved.
//

#import "ImpactTableViewController.h"

@interface ImpactTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *casualQuestionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *needHelpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *somethingBrokenCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *stuckCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emergencyCell;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

@end

@implementation ImpactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cells enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }];
    
    switch (self.ticket.impactValue) {
        case SupportTicketImpactLevelComment:
            self.casualQuestionCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SupportTicketImpactLevelNotUrgent:
            self.needHelpCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SupportTicketImpactLevelWorkaroundPossible:
            self.somethingBrokenCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SupportTicketImpactLevelBlocking:
            self.stuckCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case SupportTicketImpactLevelEmergency:
            self.emergencyCell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        default:
            break;
    }

    [self setupAccessibility];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Expecting cells to be sorted by severity
    if (indexPath.row == SupportTicketImpactLevelComment) {
        self.ticket.impactValue = SupportTicketImpactLevelComment;
        
    } else if (indexPath.row == SupportTicketImpactLevelNotUrgent) {
        self.ticket.impactValue = SupportTicketImpactLevelNotUrgent;
        
    } else if (indexPath.row == SupportTicketImpactLevelWorkaroundPossible) {
        self.ticket.impactValue = SupportTicketImpactLevelWorkaroundPossible;
        
    } else if (indexPath.row == SupportTicketImpactLevelBlocking) {
        self.ticket.impactValue = SupportTicketImpactLevelBlocking;
        
    } else if (indexPath.row == SupportTicketImpactLevelEmergency) {
        self.ticket.impactValue = SupportTicketImpactLevelEmergency;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupAccessibility
{
    [self.casualQuestionCell setAccessibilityLabel:NSLocalizedString(@"Casual question or suggestion", nil)];
    [self.casualQuestionCell setAccessibilityIdentifier:@"ticketImpactCasualCell"];

    [self.needHelpCell setAccessibilityLabel:NSLocalizedString(@"Non-urgent help needed", nil)];
    [self.needHelpCell setAccessibilityIdentifier:@"ticketImpactNeedHelpCell"];

    [self.somethingBrokenCell setAccessibilityLabel:NSLocalizedString(@"Something is broken but I can work around it", nil)];
    [self.somethingBrokenCell setAccessibilityIdentifier:@"ticketImpactSomethingBrokenCell"];

    [self.stuckCell setAccessibilityLabel:NSLocalizedString(@"I am stuck and can't get things done", nil)];
    [self.stuckCell setAccessibilityIdentifier:@"ticketImpactStuckCell"];

    [self.emergencyCell setAccessibilityLabel:NSLocalizedString(@"Emergency", nil)];
    [self.emergencyCell setAccessibilityIdentifier:@"ticketImpactEmergencyCell"];
}

@end
