
-- Cleaing Data In SQL Queries


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Standardize SaleDate Format



Select Cast(SaleDate AS Date) AS NewSaleDate
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add NewSaleDate Date;

Update PortfolioProject.dbo.NashvilleHousing
Set NewSaleDate = Cast(SaleDate AS Date)

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate;


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Populate Property Address data without Null



Select n.ParcelID, n.PropertyAddress, a.ParcelID, a.PropertyAddress, ISNULL(n.PropertyAddress, a.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing n
Join PortfolioProject.dbo.NashvilleHousing a
	On n.ParcelID = a.ParcelID
	And	n.[UniqueID ] <> a.[UniqueID ]
Where n.PropertyAddress is null


Update n	
Set PropertyAddress = ISNULL(n.PropertyAddress, a.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing n
Join PortfolioProject.dbo.NashvilleHousing a
	On n.ParcelID = a.ParcelID
	And	n.[UniqueID ] <> a.[UniqueID ]
Where n.PropertyAddress is null


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAdress into individual columns(Address, City)



SELECT PropertyAddress 
FROM PortfolioProject.dbo.NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as city
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropNewAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropNewAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropNewCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropNewCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Breaking out OwnerAdress into individual columns(Address, City, State)

SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing

Select 
parsename(Replace(OwnerAddress, ',','.') ,3),
parsename(Replace(OwnerAddress, ',','.') ,2),
parsename(Replace(OwnerAddress, ',','.') ,1)
FROM PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerNewAddress nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerNewAddress = parsename(Replace(OwnerAddress, ',','.') ,3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerNewCity nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerNewCity = parsename(Replace(OwnerAddress, ',','.') ,2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerNewState nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerNewState = parsename(Replace(OwnerAddress, ',','.') ,1)


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field



Select Distinct(SoldAsVacant), count(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


Select SoldAsVacant,
	Case When SoldAsVacant = 'Y' Then 'Yes'
		 When SoldAsVacant = 'N' Then 'No'
		 Else SoldAsVacant
		 End
FROM PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
						When SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
						End


SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 Order by
					UniqueID
					) RowNum

FROM PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)


Select *
FROM RowNumCTE
Where RowNum > 1
Order by ParcelID


-- There're 121 duplicate rows to Delete.

 Delete
 FROM RowNumCTE
 Where RowNum > 1
 --Order by ParcelID

 ----------------------------------------------------------------------------------------------------------------

 -- Removes Columns


 
 SELECT * 
 FROM PortfolioProject.dbo.NashvilleHousing


 Alter Table PortfolioProject.dbo.NashvilleHousing
 Drop Column PropertyAddress, OwnerAddress, TaxDistrict



 ----------------------------------------------------------------------------------------------------------------


 