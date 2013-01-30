Sequel.migration do
  up do
    run "insert ignore into footnotes (footnote_type_id,footnote_id,validity_start_date,validity_end_date,national) values ('05','976',str_to_date('1971-12-31', '%Y-%m-%d'),NULL,1)"
    run "insert ignore into footnote_description_periods (footnote_description_period_sid,footnote_type_id,footnote_id,validity_start_date,national) values (-216,'05','976',str_to_date('1971-12-31', '%Y-%m-%d'),1)"
    run "insert ignore into footnote_descriptions (footnote_description_period_sid,language_id,footnote_type_id,footnote_id,description,national) values (-216,'EN','05','976','Goods under this heading may be liable to Hydrocarbon Oils duty - see Volume 1, Part 12, para 12.15',1)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95611,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826001010','80',1,null)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95612,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826001090','80',1,null)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95617,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826009011','80',1,null)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95618,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826009019','80',1,null)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95619,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826009030','80',1,null)"
    run "insert ignore into footnote_association_goods_nomenclatures (goods_nomenclature_sid, footnote_type, footnote_id, validity_start_date, goods_nomenclature_item_id, productline_suffix, national, validity_end_date) values (95620,'05','976',str_to_date('1972-01-01','%Y-%m-%d'),'3826009090','80',1,null)"
  end

  down do
    run "delete from footnotes where footnote_type_id = '05' and footnote_id = '976'"
    run "delete from footnote_descriptions where footnote_type_id = '05' and footnote_id = '976'"
    run "delete from footnote_description_periods where footnote_type_id = '05' and footnote_id = '976'"
    run "delete from footnote_association_goods_nomenclatures where footnote_type = '05' and footnote_id = '976'"
  end
end
