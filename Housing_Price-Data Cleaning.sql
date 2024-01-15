
-- View the entire table

SELECT * 
FROM housingprice;

-- Populate the propery address data

SELECT 
    a.uniqueID,
    a.ParcelID,
    a.PropertyAddress,
    b.uniqueID,
    b.ParcelID,
    b.PropertyAddress,
    COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM
    housingprice a
        JOIN
    housingPrice b ON a.ParcelID = b.ParcelID
        AND a.UniqueID <> b.UniqueID
WHERE
    a.PropertyAddress IS NULL;
        
UPDATE housingprice a
JOIN housingPrice b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;




-- breaking out Propertyaddress into individual columns(address, city, state)

SELECT propertyaddress,
substring_index(PropertyAddress,',',-1),
locate(',',propertyaddress)
FROM Housingprice a;
    
SET SQL_SAFE_UPDATES = 0;

select Propertyaddress,
substring_index(Propertyaddress,',',1) as addresss,
substring_index(Propertyaddress,',',-1) as address
from housingprice;


ALter Table housingprice
ADD PropertySplitAddress varchar(255);

Update Housingprice
Set PropertySplitAddress = substring_index(Propertyaddress,',',1);

ALter Table housingprice
ADD PropertySplitCity varchar(255);

Update Housingprice
Set PropertySplitCity = substring_index(Propertyaddress,',',-1);

-- breaking out Owneraddress into individual columns(address, city, state)
select OwnerAddress,
substring_index(Owneraddress,',',1) as addresss,
substring_index(substring_index(Owneraddress,',',2),',',-1) as addresss,
substring_index(owneraddress,',',-1) as address
from housingprice;


ALter Table housingprice
ADD OwnerSplitAddress varchar(255);

Update Housingprice
Set OwnerSplitAddress = substring_index(Owneraddress,',',1);

ALter Table housingprice
ADD OwnerSplitCity varchar(255);

Update Housingprice
Set OwnerSplitCity = substring_index(substring_index(Owneraddress,',',2),',',-1);


ALter Table housingprice
ADD OwnerSplitState varchar(255);

Update Housingprice
Set OwnerSplitState = substring_index(owneraddress,',',-1);


-----------------------------------------------------------------------------------------------------
-- Change "Y" to Yes and "N" to No in SoldAsVacant Field
SELECT 
    CASE
        WHEN Soldasvacant = 'Y' THEN 'Yes'
        WHEN Soldasvacant = 'N' THEN 'No'
        ELSE Soldasvacant
    END AS Soldasvacant
FROM housingPrice;
SELECT *
FROM housingprice;

UPDATE housingprice
SET soldasvacant = CASE
        WHEN Soldasvacant = 'Y' THEN 'Yes'
        WHEN Soldasvacant = 'N' THEN 'No'
        ELSE Soldasvacant
    END;
	
----------------------------------------------------------------------------------------------------------
-- Removing dublicates

WITH RowNumCTE AS 
(SELECT *,
row_number() OVER(partition by 
	ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
) as rn
from housingprice)
SELECT * 
from RowNumCTE
WHERE rn>1;

----------------------------------------------------------------------------------------------------------
-- Delete Unsed Column
ALTER TABLE Housingprice
DROP COLUMN PropertyAddress,
DROP COLUMN OwnerAddress,
DROP COLUMN TaXDistrict;

    
SELECT count(soldasvacant)
FROM housingprice
Group by SoldAsVacant;