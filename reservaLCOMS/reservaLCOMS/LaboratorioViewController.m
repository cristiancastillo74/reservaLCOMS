//
//  LaboratorioViewController.m
//  reservaLCOMS
//
//  Created by cristian castillo on 5/20/18.
//  Copyright © 2018 cristian castillo. All rights reserved.
//

#import "LaboratorioViewController.h"
#import "controlBD.h"
@interface LaboratorioViewController ()
{
    NSMutableArray *arrayLaboratorio;
    sqlite3 *reservaBD;
    NSString *dbPathString;}

@end

@implementation LaboratorioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[controlBD sharedInstance] crearOabrirBD];
    arrayLaboratorio = [[NSMutableArray alloc] init];
    [[self LaboratorioTableView]setDelegate:self];
    [[self LaboratorioTableView]setDataSource:self];
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

- (IBAction)InsertarLaboratorioBoton:(id)sender {
    char *error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD)==SQLITE_OK){
        
        NSString *insert_Stmt=[NSString stringWithFormat:@"insert into laboratorio (codLab,idTipoLab,cupo,planta) values ('%s','%s','%s','%s')",[self.codLabField.text UTF8String],[self.idTipoLabField.text UTF8String],[self.cupoField.text UTF8String],[self.plantaField.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if(sqlite3_exec(reservaBD,insert_stmt,NULL,NULL,&error)==SQLITE_OK){
            NSLog(@"Laboratorio Insertada corecctamente");
            
            Laboratorio *laboratorio =[[Laboratorio alloc]init];
            [laboratorio setCodLab:self.codLabField.text];
            [laboratorio setIdTipoLab:self.idTipoLabField.text];
            [laboratorio setCupo:self.cupoField.text];
            [laboratorio setPlanta:self.plantaField.text];
            [arrayLaboratorio addObject:laboratorio];
        }else{
            NSLog(@"Laboratorio no insertado");
        }
        sqlite3_close(reservaBD);
    }
    
}

- (IBAction)ActualizarLaboratorioBoton:(id)sender {
    static sqlite3_stmt *statement = nil;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        char *update_Stmt = "update laboratorio set cupo=? and planta=? where codLab=?";
        if (sqlite3_prepare(reservaBD, update_Stmt, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [self.cupoField.text UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [self.plantaField.text UTF8String],-1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            Laboratorio *laboratorio = [[Laboratorio alloc]init];
            [laboratorio setCodLab:self.codLabField.text];
            [laboratorio setIdTipoLab:self.idTipoLabField.text];
            [laboratorio setCupo:self.cupoField.text];
            [laboratorio setPlanta:self.plantaField.text];
            [arrayLaboratorio addObject:laboratorio];
            
            NSLog(@"Laboratorio no modificada");
        }else{
            NSLog(@"Laboratorio no modificada");
        }
        sqlite3_close(reservaBD);
    }
}

- (IBAction)ConsultarLaboratorioBoton:(id)sender {
    sqlite3_stmt *statement;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        [arrayLaboratorio removeAllObjects];
        NSString *querySql = [NSString stringWithFormat:@"select * from laboratorio"];
        
        const char *querysql = [querySql UTF8String];
        
        if (sqlite3_prepare(reservaBD, querysql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *codLab1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *idTipoLab1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *cupo1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *planta1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                Laboratorio *laboratorio = [[Laboratorio alloc]init];
                [laboratorio setCodLab:codLab1 ];
                [laboratorio setIdTipoLab:idTipoLab1];
                [laboratorio setCupo:cupo1];
                [laboratorio setPlanta:planta1];
                [arrayLaboratorio addObject:laboratorio];
            }
        }else{
            NSLog(@"Lista vacia");
        }
        sqlite3_close(reservaBD);
    }
    [[self LaboratorioTableView]reloadData];
}



- (IBAction)EliminarLaboratorioBoton:(id)sender {
    [[self LaboratorioTableView]setEditing:!self.LaboratorioTableView.editing animated:YES];
}



- (void)deleteData:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_open([[controlBD sharedInstance].dbPath UTF8String], &reservaBD) == SQLITE_OK) {
        if (sqlite3_exec(reservaBD, [deleteQuery UTF8String], NULL, NULL, &error) == SQLITE_OK) {
            NSLog(@"Laboratorio Eliminado");
        }else{
            NSLog(@"Laboratorio no Eliminado");
        }
        sqlite3_close(reservaBD);
    }
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Laboratorio *lab = [arrayLaboratorio objectAtIndex:indexPath.row];
        [self deleteData:[NSString stringWithFormat:@"delete from laboratorio where codLab is '%s' and idTipoLab is '%s'",[lab.codLab UTF8String],[lab.idTipoLab UTF8String]]];
        [arrayLaboratorio removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayLaboratorio count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    Laboratorio *alaboratorio = [arrayLaboratorio objectAtIndex:indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"%f", laboratorio.notaFinal];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@",alaboratorio.idTipoLab, alaboratorio.cupo, alaboratorio.planta];
    return cell;
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [[self codLabField]resignFirstResponder];
    [[self idTipoLabField]resignFirstResponder];
    [[self cupoField]resignFirstResponder];
    [[self plantaField]resignFirstResponder];
}

@end
