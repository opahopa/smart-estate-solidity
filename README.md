## Smart Estate PoC solidity contracts

Inspired by [ConsesSys real estate standards](https://github.com/ConsenSys/real-estate-standards)

Includes a rough skeleton of land (spatial units) governance sysytem.
Note that this was built in one day -> there is a lot of room for improvements and this is far from production. The aim was to make as much as possible within a very limited amount of time.

#### SpatialUnitRegistry  
Land units registry (`geohash` coordinates format).

#### RightsRegistry
Manages the land units access rights, such as:

        VIEWER,
        OWNER,
        TENANT,
        INVESTOR,
        GOVT,
        CARETAKER,
        ADMIN
#### MetadataRegistry     
To be used to store information about land units, such as property rights verification documents, photographs of the land, etc

#### GovernRequest
To be used as a land unit governance instrument. Represents a fundable action proposal. To be tied to `SpatialUnit`. Implements voting mechanism mock. 
