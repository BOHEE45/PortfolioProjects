-- Standarize Date Format

select *
from PortfolioProject..[Nashville Housing]

select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..[Nashville Housing]

Update [Nashville Housing]
SET saledate = CONVERT(date,saledate)

ALTER TABLE [Nashville Housing]
Add SaleDateConverted date;

Update [Nashville Housing]
SET SaleDateConverted = CONVERT(date,saledate)

--  Populate Property Address data

select PropertyAddress
From PortfolioProject..[Nashville Housing]
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Nashville Housing] a
join PortfolioProject..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..[Nashville Housing] a
join PortfolioProject..[Nashville Housing] b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Addressm City, State)

select PropertyAddress
From PortfolioProject..[Nashville Housing]
--where propertyaddress is null
--order by parcelID	

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , len(PropertyAddress)) as Address

From PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1)

ALTER TABLE PortfolioProject..[Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject..[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1 , len(PropertyAddress)) 

select *
from PortfolioProject..[Nashville Housing]

select OwnerAddress
from PortfolioProject..[Nashville Housing]

select
PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 3 )
,PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 2 )
,PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 1 )
FROM PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject..[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 3 )

ALTER TABLE PortfolioProject..[Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject..[Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 2 )

ALTER TABLE PortfolioProject..[Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject..[Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.' ) , 1 )

select *
from PortfolioProject..[Nashville Housing]

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(Soldasvacant), count(Soldasvacant)
from PortfolioProject..[Nashville Housing]
group by Soldasvacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProject..[Nashville Housing]

update PortfolioProject..[Nashville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

-- Remove duplicates

WITH rownumCTE as(
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
					   PropertyAddress,
					   SalePrice,
					   SaleDate,
					   LegalReference
					   ORDER BY
							UniqueID
							) row_num
from PortfolioProject..[Nashville Housing]
)
select *
from rownumCTE
where row_num > 1
order by PropertyAddress

-- Delete Unused Columns

select *
from PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..[Nashville Housing]
DROP COLUMN Saledate