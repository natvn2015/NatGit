Check the changes

select refnr,nrorgnr as leistacc,kontonr as taa,epreis*anzahl as rev,packref
from bktleist
where packref<0 and refnr not in (select packref from bktleist where packref>0) order by refnr

with bkt
as
(
select refnr,anzahl
from bktleist where packref<0 AND refnr in (select packref from bktleist where packref>0)
),
bkt_pack
as
(
select b.refnr,b.nrorgnr as leistacc,b.kontonr as taa,b.epreis*b.anzahl*c.anzahl as rev,packref
from bktleist b inner join bkt c on b.packref=c.refnr
)
select * from bkt_pack
union
select refnr,nrorgnr as leistacc,kontonr as taa,epreis*anzahl as rev,packref
from bktleist
where packref<0 and refnr not in (select packref from bktleist where packref>0) 
order by refnr


select b.refnr,b.nrorgnr,b.kontonr,b.preis,b.epreis,b.anzahl,b.packref,b.kontonr,u.kto,u.hauptgrp,g.gruppe
from bktleist b left join ukto u on b.kontonr=u.ktonr
	left join hgruppen g on g.hgnr=u.hauptgrp
	inner join bktleist pak on b.refnr=pak.packref

select * from ukto where ktonr=472
--@Revenue
if {bktleist.PACKREF} < 1 then (
    if isnull({bktleist_Package.PACKREF}) = false and {bktleist_Package.PACKREF} > 0 then 
         ({bktleist_Package.EPREIS} * {bktleist.ANZAHL} * {bktleist_Package.ANZAHL} / (if {@isnet} = 1 then (100 + {MWST_Package.SATZ}) / 100 else 1)) 
           else 
         ({bktleist.EPREIS} * {bktleist.ANZAHL} / (if {@isnet} = 1 then (100 + {MWST.SATZ}) / 100 else 1))
)


--@GroupRevenue
if isnull({hgruppen.hgnr}) then(
    if isnull({hgruppen_package.gruppe}) =false and {hgruppen_package.gruppe} in [{@Food},{@Beverage},{@RoomHire},{@Media}] then {hgruppen_package.gruppe}
       
)else (
        if {hgruppen.gruppe} in [{@Food},{@Beverage},{@RoomHire},{@Media}] then {hgruppen.gruppe}
        else if isnull({hgruppen_package.gruppe}) =false and {hgruppen_package.gruppe} in [{@Food},{@Beverage},{@RoomHire},{@Media}] then {hgruppen_package.gruppe}
)

if {@GroupRevenue} = {@Food} then (
                                    AddEventFlag:= true;
                                    FoodRevenue := FoodRevenue + {@Revenue}; 
                                    TotalFoodRevenue := TotalFoodRevenue + {@Revenue}
                                
                                )
else if {@GroupRevenue} = {@Beverage} then (
                                    AddEventFlag:= true;
                                    BeverageRevenue:= BeverageRevenue + {@Revenue}; 
                                    TotalBeverageRevenue:= TotalBeverageRevenue + {@Revenue}
                                    )
else if {@GroupRevenue} = {@RoomHire} then (
                                    AddEventFlag:= true;
                                    RoomHireRevenue:= RoomHireRevenue + {@Revenue}; 
                                    TotalRoomHireRevenue:= TotalRoomHireRevenue + {@Revenue}
                                    )
else if {@GroupRevenue} = {@Media} then (
                                    AddEventFlag:= true;
                                    MediaHireRevenue:= MediaHireRevenue + {@Revenue}; 
                                    TotalMediaHireRevenue:= TotalMediaHireRevenue + {@Revenue}
                                    );
