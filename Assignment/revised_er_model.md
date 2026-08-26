# Revised Conceptual ER Model & Analysis Report
**Course:** COSC3107/3108 Database Concepts  
**Case Study:** World Health Organization (WHO) Preventable Infectious Diseases Database  
**Reference Document:** [COSC3107_DatabaseAssignment1-1-1.docx](file:///c:/Code/Assignment/COSC3107_DatabaseAssignment1-1-1.docx)

---

## 1. Visual Locations of Issues on the Provided Diagram

| Location on Diagram | Entity / Element | Issue in Original Diagram | Required Correction |
| :--- | :--- | :--- | :--- |
| **Middle Right** | `VaccineDoseSchedule` | • Misspelled attribute: `ReccomendedTiming`<br>• Disconnected from target age group (only linked to `Vaccine` with an awkward `"needs correct"` line). | • Fix spelling to `RecommendedTiming`.<br>• Link `VaccineDoseSchedule` jointly to `Vaccine` and `PopulationGroup` (e.g., infant vs. adult dosage/timings). |
| **Middle Center** | `PriorityRanking` | • Modeled as a standalone strong entity with `PriorityID {PK}` with a static `1..1` link to `PopulationGroup`. | • In the case study, priority is determined per disease when there is a vaccine shortage. Model as an associative entity `ShortagePriority` linking `Disease` and `PopulationGroup`. |
| **Middle Left** | `DiseaseStatistic` | • Stores calculated `IncidentRate` and `MortalityRate`.<br>• Duplicates `DiseaseID {PartialKey}` inside the box.<br>• Messy line looping from `Country` at the far left. | • Store raw counts `ConfirmedCases` and `MortalityDeaths` so rates can be derived dynamically per **Business Rule 2**.<br>• Remove redundant foreign keys inside conceptual entities.<br>• Remove redundant relationship line from `Country`. |
| **Bottom Center** | `Postcode` | • Modeled with no clear scope relative to `Country`. | • Connect `Country` (`1..1`) to `Postcode` (`0..*`) to scope postcodes per country. |

---

## 2. Revised UML Conceptual Class Diagram

```mermaid
classDiagram
    class Country {
        CountryID {PK}
        CountryName
        MembershipType
    }

    class CountryStatistic {
        StatisticYear {PartialKey}
        Population
        SubmissionDate
    }

    class Disease {
        DiseaseID {PK}
        DiseaseName
    }

    class Virus {
        VirusID {PK}
        ScientificName
    }

    class VirusAlias {
        AliasName {PartialKey}
    }

    class DiseaseStatistic {
        VaccinationTarget
        ActualVaccinations
        ConfirmedCases
        MortalityDeaths
    }

    class Vaccine {
        VaccineID {PK}
        VaccineName
        AdministrationRoute
    }

    class VaccineProducer {
        ProducerID {PK}
        ProducerName
    }

    class VaccineBatch {
        BatchNumber {PartialKey}
        ManufactureDate
        ExpiryDate
    }

    class PopulationGroup {
        GroupID {PK}
        GroupName
        Description
    }

    class VaccineDoseSchedule {
        DoseNumber {PartialKey}
        RecommendedTiming
        DosageVolume
        IsBooster
    }

    class ShortagePriority {
        PriorityRank
        RiskOfInfection
        RiskOfMortality
    }

    class Postcode {
        Postcode {PK}
        PopulationDensity
    }

    class Person {
        PersonID {PK}
        DateOfBirth
        Sex
        PopulationType
        IncomeClass
        EducationLevel
        EmploymentStatus
        Occupation
        HousingType
    }

    class VaccinationEvent {
        EventID {PK}
        VaccinationMonth
        VaccinationYear
        Comment
    }

    Country "1..1" -- "0..*" CountryStatistic : records
    Country "1..1" -- "0..*" Postcode : contains
    CountryStatistic "1..1" -- "0..*" DiseaseStatistic : includes
    Disease "1..1" -- "0..*" DiseaseStatistic : measured in
    Disease "0..*" -- "1..1" Virus : caused by
    Virus "1..1" -- "0..3" VirusAlias : has
    Disease "0..*" -- "1..*" Vaccine : prevented by
    Vaccine "0..*" -- "1..*" VaccineProducer : produced by
    Vaccine "1..1" -- "1..*" VaccineBatch : has
    Vaccine "1..1" -- "1..*" VaccineDoseSchedule : specifies
    PopulationGroup "1..1" -- "0..*" VaccineDoseSchedule : applies to
    Disease "1..1" -- "0..*" ShortagePriority : determines
    PopulationGroup "1..1" -- "0..*" ShortagePriority : evaluated in
    Postcode "1..1" -- "0..*" Person : resides in
    PopulationGroup "1..1" -- "0..*" Person : classifies
    Person "1..1" -- "0..*" VaccinationEvent : receives
    VaccineBatch "1..1" -- "0..*" VaccinationEvent : administered with
    VaccineDoseSchedule "1..1" -- "0..*" VaccinationEvent : fulfills
```

---

## 3. Entity & Key Specifications

| Entity | Type | Primary / Partial Key | Non-Key Attributes | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`Country`** | Strong | `CountryID {PK}` | `CountryName`, `MembershipType` | WHO Member / Associate Member countries. |
| **`CountryStatistic`** | Weak (on `Country`) | `StatisticYear {PartialKey}` | `Population`, `SubmissionDate` | Annual submission tracking (**BR 1**) and total national population. |
| **`Disease`** | Strong | `DiseaseID {PK}` | `DiseaseName` | Preventable infectious diseases. |
| **`Virus`** | Strong | `VirusID {PK}` | `ScientificName` | Causative viral agent. |
| **`VirusAlias`** | Weak (on `Virus`) | `AliasName {PartialKey}` | *None* | Up to 3 alternative scientific/common aliases. |
| **`DiseaseStatistic`** | Associative / Weak | Composite (`CountryStatistic` + `Disease`) | `VaccinationTarget`, `ActualVaccinations`, `ConfirmedCases`, `MortalityDeaths` | Stores raw metrics to derive incident, mortality, and coverage rates (**BR 2**). |
| **`Vaccine`** | Strong | `VaccineID {PK}` | `VaccineName`, `AdministrationRoute` | Vaccine products (supports combination vaccines like MMR). |
| **`VaccineProducer`** | Strong | `ProducerID {PK}` | `ProducerName` | Pharmaceutical manufacturer. |
| **`VaccineBatch`** | Weak (on `Vaccine`) | `BatchNumber {PartialKey}` | `ManufactureDate`, `ExpiryDate` | Manufactured batches. |
| **`PopulationGroup`** | Strong | `GroupID {PK}` | `GroupName`, `Description` | Target groups (Infant, Child, Adult, Elderly, Vulnerable). |
| **`VaccineDoseSchedule`** | Weak / Associative | `DoseNumber {PartialKey}` | `RecommendedTiming`, `DosageVolume`, `IsBooster` | Dosage and timing schedule specific to a vaccine and age group. |
| **`ShortagePriority`** | Associative | Composite (`Disease` + `PopulationGroup`) | `PriorityRank`, `RiskOfInfection`, `RiskOfMortality` | Prioritization allocation during vaccine shortages. |
| **`Postcode`** | Strong | `Postcode {PK}` | `PopulationDensity` | Geographical density units. |
| **`Person`** | Strong | `PersonID {PK}` | `DateOfBirth`, `Sex`, `PopulationType`, `IncomeClass`, `EducationLevel`, `EmploymentStatus`, `Occupation`, `HousingType` | Individual inoculated profile (**BR 3 & BR 4**). |
| **`VaccinationEvent`** | Strong | `EventID {PK}` | `VaccinationMonth`, `VaccinationYear`, `Comment` | Record of vaccine administration. |

---

## 4. Assessment Rubric & Business Rules Compliance

1. **Business Rule 1 (Submission Tracking)**:
   - Implemented via `CountryStatistic.SubmissionDate`.
2. **Business Rule 2 (Deriving Mortality & Incident Rates)**:
   - Raw metrics `ConfirmedCases` and `MortalityDeaths` stored in `DiseaseStatistic`.
   - $\text{Mortality Rate} = \frac{\text{MortalityDeaths}}{\text{Population}} \times 100,000$
   - $\text{Incident Rate} = \frac{\text{ConfirmedCases}}{\text{Population}} \times 100,000$
   - $\text{Vaccination Coverage} = \frac{\text{ActualVaccinations}}{\text{Population}} \times 100\%$
3. **Business Rule 3 (Demographic Data)**:
   - `Person.DateOfBirth` (dynamic age derivation), `Person.Sex`, `Person.PopulationType` (Global vs. Indigenous for 95% herd immunity calculation), and `Postcode.PopulationDensity`.
4. **Business Rule 4 (Socioeconomic Data)**:
   - `Person.IncomeClass`, `Person.EducationLevel`, `Person.EmploymentStatus`, `Person.Occupation`, and `Person.HousingType`.

---

## 5. Modeling Assumptions

1. **Age Derivation**: Storing `DateOfBirth` allows dynamic calculation of age at any vaccination date.
2. **Shortage Activation**: `ShortagePriority` is referenced only when actual vaccine doses are insufficient to satisfy `VaccinationTarget`.
3. **Combination Vaccines**: M:N cardinality between `Vaccine` and `Disease` accommodates combination vaccines like MMR.
