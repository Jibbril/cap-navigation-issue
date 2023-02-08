using { my } from '../db/schema';

service MyService {
    entity Entity as projection on my.Entity;
    entity OtherEntity as projection on my.OtherEntity;
    entity ThirdEntity as projection on my.ThirdEntity;
}