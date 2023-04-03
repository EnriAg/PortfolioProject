

--Cleaning data in sql querys

Select *
From PortfolioProject..NashvilleHousing

--Standard Date Formart

Select SaleDate,SaleDateConverted, convert(date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = convert(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = convert(Date,SaleDate)

Select SaleDateConverted, convert(date,SaleDate)
From PortfolioProject..NashvilleHousing


--Populate Property Addres data

select *
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAdress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as A
Join PortfolioProject.dbo.NashvilleHousing as B
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET propertyaddress = isnull(a.propertyaddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing as A
Join PortfolioProject.dbo.NashvilleHousing as B
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select propertyaddress
From portfolioproject.dbo.nashvillehousing
--where propertyaddres is null
--order by Parcel ID

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) as address
From portfolioproject.dbo.nashvillehousing

ALTER TABLE NashvilleHousing
Add propertysplitaddress Nvarchar (255);

Update NashvilleHousing
Set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) 

ALTER TABLE NashvilleHousing
Add propertysplitcity Nvarchar (255);

Update NashvilleHousing
Set propertysplitcity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) 

select *
from portfolioproject.dbo.nashvillehousing 


select owneraddress
from portfolioproject.dbo.nashvillehousing 

select
parsename (replace(owneraddress,',','.'), 3),
parsename (replace(owneraddress,',','.'), 2),
parsename (replace(owneraddress,',','.'), 1)
from portfolioproject.dbo.nashvillehousing 

ALTER TABLE NashvilleHousing
Add ownersplitaddress Nvarchar (255);

Update NashvilleHousing
Set ownersplitaddress = parsename (replace(owneraddress,',','.'), 3) 

ALTER TABLE NashvilleHousing
Add ownersplitcity Nvarchar (255);

Update NashvilleHousing
Set propertysplitcity = parsename (replace(owneraddress,',','.'), 2) 

ALTER TABLE NashvilleHousing
Add ownersplitstate Nvarchar (255);

Update NashvilleHousing
Set ownersplitstate = parsename (replace(owneraddress,',','.'), 1)

select *
from portfolioproject.dbo.nashvillehousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
From portfolioproject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END    
From portfolioproject.dbo.NashvilleHousing
Order by SoldAsVacant

update PortfolioProject.dbo.nashvillehousing 
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 

-- Remove duplicates

WITH rowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 Partition by ParcelID,
	              Propertyaddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				      UniqueID
				  ) row_num
				  

From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
DELETE
From rowNumCTE
Where row_num > 1
--Order by PropertyAddress

WITH rowNumCTE AS(
Select *,
     ROW_NUMBER() OVER (
	 Partition by ParcelID,
	              Propertyaddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				      UniqueID
				  ) row_num
				  


-- deleted unused columns

Select *
From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select *
From rowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate