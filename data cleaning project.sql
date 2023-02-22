select * FROM NAshvilleHousing
-- Standardize Date Format
select saledate, convert (date, saledate)from NashvilleHousing
update NashvilleHousing
set saledate = convert (date, saledate)
select saledate from NAshvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted from NAshvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

select * FROM NAshvilleHousing
order by ParcelID

select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
FROM NAshvilleHousing a
join NAshvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
FROM NAshvilleHousing a
join NAshvilleHousing b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress from NAshvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1 ,len(PropertyAddress)) as Address
from NAshvilleHousing

ALTER TABLE NashvilleHousing
Add PropertysplitAddress nvarchar(255);
Update NashvilleHousing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

ALTER TABLE NashvilleHousing
Add Propertysplitcity nvarchar(255);
Update NashvilleHousing
SET Propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1 ,len(PropertyAddress)) 

select Propertysplitcity,PropertysplitAddress from NAshvilleHousing

Select 
parsename(replace(OwnerAddress, ',' , '.') , 3)
,parsename(replace(OwnerAddress, ',' , '.') , 2)
,parsename(replace(OwnerAddress, ',' , '.') , 1)
From NashvilleHousing

--owneraddress spliting

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = parsename(replace(OwnerAddress, ',' , '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitcity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitcity = parsename(replace(OwnerAddress, ',' , '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitstate Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitstate = parsename(replace(OwnerAddress, ',' , '.') , 1)

select OwnerSplitAddress, OwnerSplitcity,OwnerSplitstate from NashvilleHousing
 
 select * from NashvilleHousing
 
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct (SoldAsVacant)
from NashvilleHousing
 
 select 
 case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
from NashvilleHousing
 
 update NashvilleHousing
 set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  end
	  
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM [portfolio project].[dbo].[NashvilleHousing]
)
--delete
--from RowNumCTE
--where row_num>1
select *
From RowNumCTE
Where row_num > 1

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From [portfolio project].[dbo].[NashvilleHousing]


ALTER TABLE [portfolio project].[dbo].[NashvilleHousing]
drop column TaxDistrict