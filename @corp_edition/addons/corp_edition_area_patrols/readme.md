# Area Patrols

## Description

Creates groups randomly patrolling in the area of the module.

## Synchronisation

* **Zero, one or several triggers**  
*Once all synched triggers are validated, the module will initialize. If no synched trigger, the module will initialize at mission start.*

* **Leader of one or more groups**  
*The units of the groups synched to the module will be duplicated to compose patrolling groups. These are the IA left in a corner of the map with dynamic simulation enabled.*

## Parameters

* **Number of groups**  
*Nombre de patrouilles qui seront créées dans la zone du module.*

* **Max units per group**  
*Maximum number of units per patrolling group.*

* **Waypoints per group**  
*Number of waypoints per patrolling group.*

* **Dynamic simulation**  
*Enables dynamic simulation for created groups.*

* **Debug**  
*When the module is initialized, the area, patrols and their waypoints will be draw on map (works only in Eden).*

## Schemes
![](https://media.githubusercontent.com/media/zgmrvn/corp-edition/master/%40corp_edition/addons/corp_edition_area_patrols/corp_edition_area_patrols_1.jpg)

## Variables
Data you can get out of the module using [getVariable](https://community.bistudio.com/wiki/getVariable) command.

* **createdGroups**  
*Contains groups created by the module.*

  * *Warning, the variable is not updated during mission's life and can contain groups which does not exist anymore. It's up to you to check in your scripts.*

  * *This variable is available server side only.*
