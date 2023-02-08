# Issue with path resolution
This repo showcases an issue with the error messages being returned when a path is not found. The scenario is the following:

- We have three entities: 'Entity', 'OtherEntity' and 'ThirdEntity'. Entity to OtherEntity is a one-to-one association, OtherEntity to ThirdEntity is one-to-many. 
- For the first Entity, both otherEntity and the thirdEntities exist. So going to [http://localhost:4004/my/Entity(1)/otherEntity/thirdEntities](http://localhost:4004/my/Entity(1)/otherEntity/thirdEntities) shows the correct data.
- However, for the second Entity, the otherEntity association points to an id that does not exist. So going to [http://localhost:4004/my/Entity(2)/otherEntity](http://localhost:4004/my/Entity(2)/otherEntity) returns nothing. This is correct. However, when we add the thirdEntities association we get a 404 error like here: [http://localhost:4004/my/Entity(2)/otherEntity/thirdEntities](http://localhost:4004/my/Entity(2)/otherEntity/thirdEntities). Shouldn't this also return nothing without causing errors? 
- The reason why this is relevant is that in the UI we have a [list report](http://localhost:4004/app/webapp/index.html) showing the Entites, and then tables for the related thirdEntities for each Entity. If there is no otherEntity, the thirdEntities table should simply be empty, but in stead it is throwing an error. 
- We believe that something like the following code change in the @sap/cds/libs folder would fix the issue:

```
diff --git a/node_modules/@sap/cds/libx/_runtime/common/generic/crud.js b/node_modules/@sap/cds/libx/_runtime/common/generic/crud.js
index 01b20b3..7d2ab08 100644
--- a/node_modules/@sap/cds/libx/_runtime/common/generic/crud.js
+++ b/node_modules/@sap/cds/libx/_runtime/common/generic/crud.js
@@ -45,7 +45,14 @@ exports.impl = cds.service.impl(function () {
     let pathExistsQuery
     const { ref } = (req.query.INSERT && req.query.INSERT.into) || (req.query.SELECT && req.query.SELECT.from) || {}
     // REVISIT: why is copy necessary?
-    if (ref && ref.length > 1) pathExistsQuery = SELECT(1).from({ ref: deepCopyArray(ref.slice(0, -1)) })
+    if (ref && ref.length > 1) {
+        // READ requests should test paths down to the last keyed segment
+        let ixLastWithKey = ref.length - 2;
+        if (req.event === 'READ') {
+            ixLastWithKey = ref.length; while (--ixLastWithKey) if (ref[ixLastWithKey].where) break; 
+        }
+        pathExistsQuery = SELECT(1).from({ ref: deepCopyArray(ref.slice(0, ixLastWithKey + 1)) })
+    }
```