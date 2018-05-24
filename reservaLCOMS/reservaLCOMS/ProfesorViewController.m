//
//  ProfesorViewController.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "ProfesorViewController.h"
#import "controlBD.h"

@interface ProfesorViewController ()
{
    NSMutableArray *arrayProfesor;
    sqlite3 *reservaBD;
    NSString *dbPathString;
}

@end

@implementation ProfesorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[controlBD sharedInstance] crearOabrirBD];
    arrayProfesor = [[NSMutableArray alloc] init];
    [[self ProfesoresTableView]setDelegate:self];
    [[self ProfesoresTableView]setDataSource:self];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)InsertarProfesorBoton:(id)sender {
    
    char *error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        NSString *insert_Stmt = [NSString stringWithFormat:@"insert into profesor (idProfesor,nombre) values ('%s','%s')",[self.idProfesorField.text UTF8String],[self.nombreProfesorField.text UTF8String]];
        
        const char *insert_stmt = [insert_Stmt UTF8String];
        
        if (sqlite3_exec(reservaBD, insert_stmt, NULL, NULL, &error) == SQLITE_OK) {
            NSLog(@"Profesor insertado correctamente");
            Profesor *profesor = [[Profesor alloc]init];
            [profesor setIdProfesor:self.idProfesorField.text];
            [profesor setNombreProfesor:self.nombreProfesorField.text];
            [arrayProfesor addObject:profesor];
        }else{
            NSLog(@"Profesor no insertado");
        }
        sqlite3_close(reservaBD);
    }
}

- (IBAction)SeleccionarProfesorBoton:(id)sender {
    sqlite3_stmt *statement;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        [arrayProfesor removeAllObjects];
        NSString *querySql = [NSString stringWithFormat:@"select * from profesor"];
        
        const char *querysql = [querySql UTF8String];
        
        if (sqlite3_prepare(reservaBD, querysql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *idProfesor1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *nombreProfesor1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                Profesor *profesor = [[Profesor alloc]init];
                [profesor setIdProfesor:idProfesor1 ];
                [profesor setNombreProfesor:nombreProfesor1];
                 
                [arrayProfesor addObject:profesor];
            }
        }else{
            NSLog(@"Lista vacia");
        }
        sqlite3_close(reservaBD);
    }
    [[self ProfesoresTableView]reloadData];
}

- (IBAction)ActualizarProfesorBoton:(id)sender {
    
    static sqlite3_stmt *statement = nil;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        char *update_Stmt = "update profesor set nombre=? where idProfesor=?";
        if (sqlite3_prepare(reservaBD, update_Stmt, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [self.nombreProfesorField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            Profesor *profesor = [[Profesor alloc]init];
            [profesor setNombreProfesor:self.nombreProfesorField.text ];
            [arrayProfesor addObject:profesor];
            
            NSLog(@"Profesor modificado");
        }else{
            NSLog(@"Profesor no modificado");
        }
        sqlite3_close(reservaBD);
    }
}

- (IBAction)EliminarProfesorBoton:(id)sender {
    
    [[self ProfesoresTableView]setEditing:!self.ProfesoresTableView.editing animated:YES];
}

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        if (sqlite3_exec(reservaBD, [deleteQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
            NSLog(@"Profesor Eliminado");
        }else{
            NSLog(@"Profesor no Eliminado");
        }
        sqlite3_close(reservaBD);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayProfesor count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Profesor *pProfesor = [arrayProfesor objectAtIndex:indexPath.row];
    cell.textLabel.text = pProfesor.idProfesor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",pProfesor.idProfesor,pProfesor.nombreProfesor];
    return cell;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [[self idProfesorField]resignFirstResponder];
    [[self nombreProfesorField]resignFirstResponder];
    
}


@end
