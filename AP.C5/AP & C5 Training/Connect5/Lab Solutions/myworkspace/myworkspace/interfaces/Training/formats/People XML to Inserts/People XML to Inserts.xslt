<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="http://pilotfish.sqlxml" version="1.0">
  <xsl:template match="/People">
    <ns1:SQLXML>
      <xsl:for-each select="Person">
        <ns1:Insert>
          <PEOPLE>
            <FIRST_NAME>
              <xsl:value-of select="Name/First" />
            </FIRST_NAME>
            <MIDDLE_NAME>
              <xsl:value-of select="Name/Middle" />
            </MIDDLE_NAME>
            <LAST_NAME>
              <xsl:value-of select="Name/Last" />
            </LAST_NAME>
            <GENDER>
              <xsl:value-of select="Gender" />
            </GENDER>
            <SSN>
              <xsl:value-of select="SSN" />
            </SSN>
            <BIRTHDATE>
              <xsl:value-of select="BirthDate" />
            </BIRTHDATE>
            <OCCUPATION>
              <xsl:value-of select="Occupation" />
            </OCCUPATION>
            <VEHICLE_MAKE>
              <xsl:value-of select="Vehicle/Make" />
            </VEHICLE_MAKE>
            <VEHICLE_MODEL>
              <xsl:value-of select="Vehicle/Model" />
            </VEHICLE_MODEL>
            <ADDRESS_LINE_1>
              <xsl:value-of select="Address/Line1" />
            </ADDRESS_LINE_1>
            <ADDRESS_LINE_2 />
            <CITY>
              <xsl:value-of select="Address/City" />
            </CITY>
            <STATE>
              <xsl:value-of select="Address/State" />
            </STATE>
            <ZIP>
              <xsl:value-of select="Address/Zip" />
            </ZIP>
          </PEOPLE>
        </ns1:Insert>
      </xsl:for-each>
    </ns1:SQLXML>
  </xsl:template>
</xsl:stylesheet>

