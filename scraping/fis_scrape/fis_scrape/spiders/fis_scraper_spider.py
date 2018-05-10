from scrapy import Spider, Request
from fis_scrape.items import FisScrapeItem

# defined list from preliminary scrape
race_id_lst = ['1436', '1422', '1439', '1464', '1470', '1469', '1461', '1477', '1476', '1480', '1483', '1484', '1482', '1491', '1488', '1466', '1487', '1492', '1475', '1496', '1495', '1565', '1474', '1501', '1502', '1505', '1509', '1503', '1511', '1521', '1514', '1437', '1438', '1423', '1440', '1465', '1471', '1472', '1463', '1462', '1479', '1478', '1481', '1485', '1486', '1493', '1467', '1468', '1489', '1490', '1494', '1497', '1498', '1499', '1500', '1525', '1526', '1508', '1507', '1512', '1506', '1510', '1551', '1515', '1513', '1516', '1451', '1449', '1443', '1454', '1416', '1414', '1404', '1524', '1382', '1410', '1381', '1393', '1411', '1388', '1390', '1431', '1408', '1385', '1432', '1406', '1429', '1430', '1622', '1402', '1380', '1427', '1399', '1419', '1538', '1418', '1424', '1367', '1452', '1450', '1444', '1535', '1417', '1415', '1456', '1405', '1383', '1412', '1384', '1413', '1394', '1389', '1392', '1387', '1386', '1433', '1409', '1434', '1441', '1428', '1407', '1442', '1378', '1401', '1379', '1403', '1537', '1420', '1400', '1421', '1426', '1425', '1357', '1362', '1314', '1364', '1301', '1306', '1304', '1296', '1303', '1342', '1343', '1347', '1338', '1349', '1339', '1310', '1311', '1460', '1313', '1336', '1329', '1335', '1332', '1368', '1533', '1363', '1358', '1315', '1365', '1299', '1300', '1307', '1305', '1297', '1298', '1302', '1345', '1344', '1308', '1340', '1309', '1346', '1348', '1341', '1312', '1294', '1330', '1295', '1541', '1334', '1331', '1337', '1333', '1372', '1369', '1373', '1374', '1279', '1355', '1275', '1254', '1253', '1200', '1262', '1263', '1245', '1257', '1259', '1236', '1258', '1241', '1242', '1238', '1271', '1249', '1250', '1272', '1233', '1282', '1283', '1268', '1281', '1266', '1229', '1217', '1353', '1529', '1375', '1530', '1280', '1376', '1277', '1276', '1255', '1256', '1252', '1201', '1264', '1265', '1246', '1260', '1261', '1240', '1243', '1244', '1239', '1377', '1251', '1273', '1274', '1285', '1284', '1270', '1234', '1235', '1286', '1269', '1267', '1230', '1354', '1370', '1292', '1136', '1135', '1133', '1152', '1151', '1176', '1157', '1163', '1159', '1158', '1180', '1181', '1128', '1168', '1169', '1132', '1145', '1144', '1124', '1141', '1148', '1189', '1291', '1137', '1138', '1194', '1134', '1154', '1153', '1178', '1160', '1164', '1161', '1182', '1183', '1142', '1129', '1534', '1173', '1143', '1540', '1131', '1146', '1127', '1195', '1179', '1187', '1058', '1062', '1065', '1066', '1073', '1079', '1075', '1080', '1082', '1087', '1081', '1089', '1090', '1088', '1097', '1095', '1096', '1098', '1105', '1106', '1103', '1107', '1115', '1120', '1192', '1116', '1059', '1060', '1061', '1067', '1068', '1071', '1072', '1122', '1078', '1083', '1084', '1085', '1092', '1091', '1086', '1109', '1094', '1093', '1110', '1099', '1100', '1111', '1101', '1113', '1102', '1118', '1114', '1193']

class FisScrapeSpider(Spider):
    name = "fis_scrape_spider"
    allowed_urls = ['http://www.worldloppet.com/']
    start_urls = ['http://www.worldloppet.com/browse.php?id=' + str(x) for x in race_id_lst] #switch to list above once finalized

    # Start urls above are a scraped list of worldloppet races from 2013-2018
    # The page shows up to the first 100 race finishers
    # This function scrapes the table of these fastest finishers
    # If there are 100 racers, it checks for the urls of paginated results
    # e.g. finishers 101-200, 201-252
    # These urls are fed into a Request object which can be called later
    def parse(self, response):
        rows = response.xpath('//table[@class="table"]/tr')
        for i in range(0, len(rows)):
            race_name, race_description = response.xpath("//p[@class='titolo']/text()").extract()
            racer_nationality = rows[i].xpath('./td[3]/text()').extract_first()
            racer_time = rows[i].xpath('./td[4]/text()').extract_first()

            item = FisScrapeItem()
            item['race_name'] = race_name
            item['race_description'] = race_description
            item['racer_nationality'] = racer_nationality
            item['racer_time'] = racer_time

            yield item

        #check to see if the page is 'maxed out' at 100
        #if so, create list of pages to scrape next
        row_index = response.xpath('//table[@class="table"]/tr/td[1]/text()').extract()
        if row_index[-1] == "100.":
            pagination_suffixes = response.xpath('//div[@class="elenco"]//@href').extract()
            pagination_urls = ['http://www.worldloppet.com/' + suffix for suffix in pagination_suffixes]

            for url in pagination_urls:
                yield Request(url = url, callback = self.additional_parsing)

    def additional_parsing(self, response):
        rows = response.xpath('//table[@class="table"]/tr')
        for i in range(0, len(rows)):
            race_name, race_description = response.xpath("//p[@class='titolo']/text()").extract()
            racer_nationality = rows[i].xpath('./td[3]/text()').extract_first()
            racer_time = rows[i].xpath('./td[4]/text()').extract_first()

            item = FisScrapeItem()
            item['race_name'] = race_name
            item['race_description'] = race_description
            item['racer_nationality'] = racer_nationality
            item['racer_time'] = racer_time

            yield item
