namespace my;

entity Entity {
    key id: Integer;
    prop1: String;

    otherEntity: Association to OtherEntity;
}

entity OtherEntity {
    key id: Integer;
    prop1: String;

    thirdEntities: Association to many ThirdEntity on 
        thirdEntities.otherEntity = $self;
}

entity ThirdEntity {
    key id: Integer;
    prop1: String;

    otherEntity: Association to OtherEntity;
}
