import EventIcon from "@mui/icons-material/Event";
import FastForwardIcon from "@mui/icons-material/FastForward";
import UserIcon from "@mui/icons-material/Group";
import HttpsIcon from "@mui/icons-material/Https";
import NoEncryptionIcon from "@mui/icons-material/NoEncryption";
import PageviewIcon from "@mui/icons-material/Pageview";
import ViewListIcon from "@mui/icons-material/ViewList";
import RoomIcon from "@mui/icons-material/ViewList";
import VisibilityIcon from "@mui/icons-material/Visibility";
import MessageIcon from "@mui/icons-material/Message";
import PersonAddIcon from "@mui/icons-material/PersonAdd";
import RemoveCircleIcon from "@mui/icons-material/RemoveCircle";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogTitle from "@mui/material/DialogTitle";
import DialogContent from "@mui/material/DialogContent";
import DialogActions from "@mui/material/DialogActions";
import Autocomplete from "@mui/material/Autocomplete";
import { TextField as MuiTextField } from "@mui/material";
import CircularProgress from "@mui/material/CircularProgress";
import { useTheme } from "@mui/material/styles";
import { useState } from "react";
import {
  BooleanField,
  BulkDeleteButton,
  DateField,
  Datagrid,
  DatagridConfigurable,
  DeleteButton,
  ExportButton,
  FunctionField,
  List,
  ListProps,
  NumberField,
  Pagination,
  ReferenceField,
  ReferenceManyField,
  ResourceProps,
  SearchInput,
  SelectColumnsButton,
  SelectField,
  Show,
  ShowProps,
  Tab,
  TabbedShowLayout,
  TextField,
  TopToolbar,
  useRecordContext,
  useTranslate,
  useDataProvider,
  useRefresh,
  useNotify,
  useGetList,
} from "react-admin";

import {
  RoomDirectoryBulkUnpublishButton,
  RoomDirectoryBulkPublishButton,
  RoomDirectoryUnpublishButton,
  RoomDirectoryPublishButton,
} from "./room_directory";
import { DATE_FORMAT } from "../components/date";
import storage from "../storage";

const RoomPagination = () => <Pagination rowsPerPageOptions={[10, 25, 50, 100, 500, 1000]} />;

const RoomTitle = () => {
  const record = useRecordContext();
  const translate = useTranslate();
  let name = "";
  if (record) {
    name = record.name !== "" ? record.name : record.id;
  }

  return (
    <span>
      {translate("resources.rooms.name", 1)} {name}
    </span>
  );
};

const RoomShowActions = () => {
  const record = useRecordContext();
  const publishButton = record?.public ? <RoomDirectoryUnpublishButton /> : <RoomDirectoryPublishButton />;
  // FIXME: refresh after (un)publish
  return (
    <TopToolbar>
      {publishButton}
      <DeleteButton
        mutationMode="pessimistic"
        confirmTitle="resources.rooms.action.erase.title"
        confirmContent="resources.rooms.action.erase.content"
      />
    </TopToolbar>
  );
};

// Join Room as Admin Button
const JoinRoomAsAdminButton = () => {
  const record = useRecordContext();
  const dataProvider = useDataProvider();
  const refresh = useRefresh();
  const notify = useNotify();
  const translate = useTranslate();

  const handleJoin = async () => {
    if (!record?.room_id) return;

    const currentUser = storage.getItem("user_id");
    if (!currentUser) return;

    try {
      await dataProvider.addRoomMember({
        room_id: record.room_id,
        user_id: currentUser,
      });
      notify(translate("resources.rooms.action.joined_room", { _: "You joined the room!" }), { 
        type: "success" 
      });
      refresh();
    } catch (error: any) {
      notify(error.message || translate("ra.notification.http_error", { _: "Error joining room" }), { 
        type: "error" 
      });
    }
  };

  return (
    <Button
      onClick={handleJoin}
      variant="outlined"
      startIcon={<PersonAddIcon />}
      size="small"
      color="primary"
      sx={{ marginRight: 2 }}
    >
      {translate("resources.rooms.action.join_as_admin", { _: "Join Room as Admin" })}
    </Button>
  );
};

// Add Member Button Component
const AddMemberButton = () => {
  const record = useRecordContext();
  const [open, setOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState<any>(null);
  const dataProvider = useDataProvider();
  const refresh = useRefresh();
  const notify = useNotify();
  const translate = useTranslate();

  // Fetch users list
  const { data: users, isLoading } = useGetList("users", {
    pagination: { page: 1, perPage: 100 },
    sort: { field: "name", order: "ASC" },
    filter: { deactivated: false },
  });

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    setOpen(false);
    setSelectedUser(null);
  };

  const handleAdd = async () => {
    if (!selectedUser || !record?.room_id) return;

    try {
      await dataProvider.addRoomMember({
        room_id: record.room_id,
        user_id: selectedUser.id,
      });
      notify(translate("ra.notification.created", { smart_count: 1, _: "Member added successfully" }), { 
        type: "success" 
      });
      handleClose();
      refresh();
    } catch (error: any) {
      notify(error.message || translate("ra.notification.http_error", { _: "Error adding member" }), { 
        type: "error" 
      });
    }
  };

  return (
    <>
      <Button
        onClick={handleOpen}
        startIcon={<PersonAddIcon />}
        size="small"
        sx={{ marginLeft: 2 }}
      >
        {translate("resources.rooms.action.add_member", { _: "Add Member" })}
      </Button>
      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>{translate("resources.rooms.action.add_member", { _: "Add Member" })}</DialogTitle>
        <DialogContent>
          <Box sx={{ paddingTop: 2 }}>
            <Autocomplete
              options={users || []}
              getOptionLabel={(option: any) => option.displayname || option.id || ""}
              loading={isLoading}
              value={selectedUser}
              onChange={(event, newValue) => setSelectedUser(newValue)}
              renderInput={(params) => (
                <MuiTextField
                  {...params}
                  label={translate("resources.users.name", { smart_count: 1, _: "User" })}
                  InputProps={{
                    ...params.InputProps,
                    endAdornment: (
                      <>
                        {isLoading ? <CircularProgress color="inherit" size={20} /> : null}
                        {params.InputProps.endAdornment}
                      </>
                    ),
                  }}
                />
              )}
              fullWidth
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>
            {translate("ra.action.cancel", { _: "Cancel" })}
          </Button>
          <Button onClick={handleAdd} variant="contained" disabled={!selectedUser}>
            {translate("ra.action.add", { _: "Add" })}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

// Remove Member Button Component
const RemoveMemberButton = ({ userId }: { userId: string }) => {
  const record = useRecordContext();
  const [open, setOpen] = useState(false);
  const dataProvider = useDataProvider();
  const refresh = useRefresh();
  const notify = useNotify();
  const translate = useTranslate();

  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);

  const handleRemove = async () => {
    if (!record?.room_id || !userId) return;

    try {
      await dataProvider.removeRoomMember({
        room_id: record.room_id,
        user_id: userId,
        reason: "Removed by admin",
      });
      notify(translate("ra.notification.deleted", { smart_count: 1, _: "Member removed successfully" }), { 
        type: "success" 
      });
      handleClose();
      refresh();
    } catch (error: any) {
      notify(error.message || translate("ra.notification.http_error", { _: "Error removing member" }), { 
        type: "error" 
      });
    }
  };

  return (
    <>
      <Button
        onClick={handleOpen}
        startIcon={<RemoveCircleIcon />}
        size="small"
        color="error"
      >
        {translate("ra.action.remove", { _: "Remove" })}
      </Button>
      <Dialog open={open} onClose={handleClose}>
        <DialogTitle>{translate("resources.rooms.action.remove_member", { _: "Remove Member" })}</DialogTitle>
        <DialogContent>
          <Box sx={{ padding: 2 }}>
            {translate("resources.rooms.action.remove_member_confirm", {
              _: "Are you sure you want to remove this member from the room?",
            })}
          </Box>
          <Box sx={{ paddingLeft: 2, fontWeight: "bold" }}>{userId}</Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>
            {translate("ra.action.cancel", { _: "Cancel" })}
          </Button>
          <Button onClick={handleRemove} variant="contained" color="error">
            {translate("ra.action.remove", { _: "Remove" })}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export const RoomShow = (props: ShowProps) => {
  const translate = useTranslate();
  return (
    <Show {...props} actions={<RoomShowActions />} title={<RoomTitle />}>
      <TabbedShowLayout>
        <Tab label="synapseadmin.rooms.tabs.basic" icon={<ViewListIcon />}>
          <TextField source="room_id" />
          <TextField source="name" />
          <TextField source="topic" />
          <TextField source="canonical_alias" />
          <ReferenceField source="creator" reference="users">
            <TextField source="id" />
          </ReferenceField>
        </Tab>

        <Tab label="synapseadmin.rooms.tabs.detail" icon={<PageviewIcon />} path="detail">
          <TextField source="joined_members" />
          <TextField source="joined_local_members" />
          <TextField source="joined_local_devices" />
          <TextField source="state_events" />
          <TextField source="version" />
          <TextField source="encryption" emptyText={translate("resources.rooms.enums.unencrypted")} />
        </Tab>

        <Tab label="synapseadmin.rooms.tabs.members" icon={<UserIcon />} path="members">
          <Box sx={{ display: "flex", alignItems: "center", marginBottom: 2, gap: 1 }}>
            <JoinRoomAsAdminButton />
            <AddMemberButton />
          </Box>
          <ReferenceManyField reference="room_members" target="room_id" label={false}>
            <Datagrid style={{ width: "100%" }} rowClick={id => "/users/" + id} bulkActionButtons={false}>
              <TextField source="id" sortable={false} label="resources.users.fields.id" />
              <ReferenceField
                label="resources.users.fields.displayname"
                source="id"
                reference="users"
                sortable={false}
                link=""
              >
                <TextField source="displayname" sortable={false} />
              </ReferenceField>
              <FunctionField
                label="resources.rooms.fields.actions"
                sortable={false}
                render={(record: any) => <RemoveMemberButton userId={record.id} />}
              />
            </Datagrid>
          </ReferenceManyField>
        </Tab>

        <Tab label="synapseadmin.rooms.tabs.permission" icon={<VisibilityIcon />} path="permission">
          <BooleanField source="federatable" />
          <BooleanField source="public" />
          <SelectField
            source="join_rules"
            choices={[
              { id: "public", name: "resources.rooms.enums.join_rules.public" },
              { id: "knock", name: "resources.rooms.enums.join_rules.knock" },
              { id: "invite", name: "resources.rooms.enums.join_rules.invite" },
              {
                id: "private",
                name: "resources.rooms.enums.join_rules.private",
              },
            ]}
          />
          <SelectField
            source="guest_access"
            choices={[
              {
                id: "can_join",
                name: "resources.rooms.enums.guest_access.can_join",
              },
              {
                id: "forbidden",
                name: "resources.rooms.enums.guest_access.forbidden",
              },
            ]}
          />
          <SelectField
            source="history_visibility"
            choices={[
              {
                id: "invited",
                name: "resources.rooms.enums.history_visibility.invited",
              },
              {
                id: "joined",
                name: "resources.rooms.enums.history_visibility.joined",
              },
              {
                id: "shared",
                name: "resources.rooms.enums.history_visibility.shared",
              },
              {
                id: "world_readable",
                name: "resources.rooms.enums.history_visibility.world_readable",
              },
            ]}
          />
        </Tab>

        <Tab label={translate("resources.room_state.name", { smart_count: 2 })} icon={<EventIcon />} path="state">
          <ReferenceManyField reference="room_state" target="room_id" label={false}>
            <Datagrid style={{ width: "100%" }} bulkActionButtons={false}>
              <TextField source="type" sortable={false} />
              <DateField source="origin_server_ts" showTime options={DATE_FORMAT} sortable={false} />
              <TextField source="content" sortable={false} />
              <ReferenceField source="sender" reference="users" sortable={false}>
                <TextField source="id" />
              </ReferenceField>
            </Datagrid>
          </ReferenceManyField>
        </Tab>

        <Tab label="resources.rooms.tabs.messages" icon={<MessageIcon />} path="messages">
          <ReferenceManyField reference="room_messages" target="room_id" label={false}>
            <Datagrid style={{ width: "100%" }} bulkActionButtons={false}>
              <DateField source="origin_server_ts" showTime options={DATE_FORMAT} sortable={false} />
              <ReferenceField source="sender" reference="users" sortable={false} link="show">
                <TextField source="id" />
              </ReferenceField>
              <TextField source="msgtype" sortable={false} label="resources.rooms.fields.message_type" />
              <TextField source="body" sortable={false} label="resources.rooms.fields.message_body" />
            </Datagrid>
          </ReferenceManyField>
        </Tab>

        <Tab label="resources.forward_extremities.name" icon={<FastForwardIcon />} path="forward_extremities">
          <Box
            sx={{
              fontFamily: "Roboto, Helvetica, Arial, sans-serif",
              margin: "0.5em",
            }}
          >
            {translate("resources.rooms.helper.forward_extremities")}
          </Box>
          <ReferenceManyField reference="forward_extremities" target="room_id" label={false}>
            <Datagrid style={{ width: "100%" }} bulkActionButtons={false}>
              <TextField source="id" sortable={false} />
              <DateField source="received_ts" showTime options={DATE_FORMAT} sortable={false} />
              <NumberField source="depth" sortable={false} />
              <TextField source="state_group" sortable={false} />
            </Datagrid>
          </ReferenceManyField>
        </Tab>
      </TabbedShowLayout>
    </Show>
  );
};

const RoomBulkActionButtons = () => (
  <>
    <RoomDirectoryBulkPublishButton />
    <RoomDirectoryBulkUnpublishButton />
    <BulkDeleteButton
      confirmTitle="resources.rooms.action.erase.title"
      confirmContent="resources.rooms.action.erase.content"
      mutationMode="pessimistic"
    />
  </>
);

const roomFilters = [<SearchInput source="search_term" alwaysOn />];

const RoomListActions = () => (
  <TopToolbar>
    <SelectColumnsButton />
    <ExportButton />
  </TopToolbar>
);

export const RoomList = (props: ListProps) => {
  const theme = useTheme();

  return (
    <List
      {...props}
      pagination={<RoomPagination />}
      sort={{ field: "name", order: "ASC" }}
      filters={roomFilters}
      actions={<RoomListActions />}
    >
      <DatagridConfigurable
        rowClick="show"
        bulkActionButtons={<RoomBulkActionButtons />}
        omit={["joined_local_members", "state_events", "version", "federatable"]}
      >
        <BooleanField
          source="is_encrypted"
          sortBy="encryption"
          TrueIcon={HttpsIcon}
          FalseIcon={NoEncryptionIcon}
          label={<HttpsIcon />}
          sx={{
            [`& [data-testid="true"]`]: { color: theme.palette.success.main },
            [`& [data-testid="false"]`]: { color: theme.palette.error.main },
          }}
        />
        <FunctionField source="name" render={record => record["name"] || record["canonical_alias"] || record["id"]} />
        <TextField source="joined_members" />
        <TextField source="joined_local_members" />
        <TextField source="state_events" />
        <TextField source="version" />
        <BooleanField source="federatable" />
        <BooleanField source="public" />
      </DatagridConfigurable>
    </List>
  );
};

const resource: ResourceProps = {
  name: "rooms",
  icon: RoomIcon,
  list: RoomList,
  show: RoomShow,
};

export default resource;
