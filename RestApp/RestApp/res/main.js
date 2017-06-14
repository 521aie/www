require('JsonHelper,TreeBuilder,TreeNodeUtils,NSMutableDictionary,NSMutableArray,NSNull');
defineClass('SelectMultiMenuListView', {
            parseResult: function(result) {
            var map = JsonHelper.transMap(result);
            var kindArrs = map.objectForKey("kindMenus");
            self.setKindMenuList(JsonHelper.transList_objName(kindArrs, "KindMenu"));
            
            self.setAllNodeList(TreeBuilder.buildTree(self.kindMenuList()));
            self.setHeadList(TreeNodeUtils.convertEndNode(self.allNodeList()));
            
            var detailtArrs = map.objectForKey("sampleMenus");
            self.setDetailList(JsonHelper.transList_objName(detailtArrs, "SampleMenuVO"));
            
            if (self.detailList() == null || self.detailList().count() == 0) {
            return;
            }
            var arr = null;
            self.setDetailMap(NSMutableDictionary.alloc().init());
            self.setMenuMap(NSMutableDictionary.alloc().init());
            
            var detailArr = self.detailList().toJS();
            
            for (var i = 0; i < detailArr.length; i++) {
            var menu = detailArr[i];
            
            if (menu.kindMenuId() == NSNull.null() || menu.kindMenuId() == null || typeof menu.kindMenuId() === 'undefined') {
            continue;
            }
            
            
            arr = self.detailMap().objectForKey(menu.kindMenuId());
            if (!arr) {
            arr = NSMutableArray.array();
            } else {
            self.detailMap().removeObjectForKey(menu.kindMenuId());
            }
            arr.addObject(menu);
            self.detailMap().setObject_forKey(arr, menu.kindMenuId());
            self.menuMap().setObject_forKey(menu, menu.__id());
            }
            
            self.pushNotification();
            },
            });